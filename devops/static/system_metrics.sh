#!/bin/bash

# aim : scrape avg-CPU-load & send it to statsd ,
#     : breaking it down into various categories: last 1 min , last 5 min , last 15 min
# sample usage : "./<this-script-name>.sh &"
#              : "&" sign at the end will run this script in background
# this script is to be run as a cron
# however due to systemd restrictions in docker containers , we are running it as infinite for loop

# Source the environment file
source /home/ubuntu/assets/env_file.env

# hostname as metric prefix
HOSTNAME=$(hostname)

send_metrics_to_statsd() {
    local counter=$1
    local metric_suffix=$2
    local final_metric="$HOSTNAME.$metric_suffix"

    # print to console
    # echo "$final_metric = $counter"

    # send metric command
    echo "$final_metric:$counter|g" | nc -w 1 -u $STATSD_HOST $STATSD_PORT
}

get_cores() {
    local cpu_core_count=$(grep -c ^processor /proc/cpuinfo)

    # this echo returns the value to caller
    echo "$cpu_core_count"
}

get_process_id() {
    # systemctl show -p MainPID cores-and-threads
    local pid=$(systemctl show -p MainPID "$SYSTEM_CTL_SERVICE_NAME" | cut -d= -f2)
    echo "$pid"
}

emit_ctx_switching_metrics() {
    # /proc/5100/status | grep ctx
    local pid=$1
    local status_content=$(</proc/$pid/status)
    local voluntary=$(echo "$status_content" | grep '^voluntary_ctxt_switches' | awk '{print $2}')
    local nonvoluntary=$(echo "$status_content" | grep '^nonvoluntary_ctxt_switches' | awk '{print $2}')
    local total=$((voluntary + nonvoluntary))
    local diff_vol_nonvol=$((voluntary - nonvoluntary))
    local diff_nonvol_vol=$((nonvoluntary - voluntary))

    send_metrics_to_statsd $voluntary "ctx.vol"
    send_metrics_to_statsd $nonvoluntary "ctx.non_vol"
    send_metrics_to_statsd $total "ctx.total"
    send_metrics_to_statsd $diff_vol_nonvol "ctx.diff_vol_nonvol"
    send_metrics_to_statsd $diff_nonvol_vol "ctx.diff_nonvol_vol"
}

emit_ctx_switching_rate_metrics() {
    # pidstat -w -h -p 5100 1 10
    local pid=$1
    read _ _ _ cswch nvcswch _ <<<$(pidstat -w -h -p "$pid" 1 1 | tail -n 1)
    local total_rate=$(echo "$cswch + $nvcswch" | bc)
    send_metrics_to_statsd $cswch "ctx_rate.vol"
    send_metrics_to_statsd $nvcswch "ctx_rate.non_vol"
    send_metrics_to_statsd $total_rate "ctx_rate.total"
}

emit_load_avg_metrics() {
    local cores=$1

    # get 1, 5, 15 min load avg
    read load1 load5 load15 <<<$(uptime | awk -F'load average: ' '{print $2}' | tr -d ',')

    # divide by number of cores
    local norm1=$(echo "scale=2; $load1 / $cores" | bc)
    local norm5=$(echo "scale=2; $load5 / $cores" | bc)
    local norm15=$(echo "scale=2; $load15 / $cores" | bc)

    send_metrics_to_statsd $norm1 "load_avg.one"
    send_metrics_to_statsd $norm5 "load_avg.five"
    send_metrics_to_statsd $norm15 "load_avg.fifteen"
}

emit_cpu_metrics() {
    # Read 'cpu' line, remove 'cpu' label
    local cpu_values=($(grep '^cpu ' /proc/stat | cut -d ' ' -f2-))

    # Known labels (up to 10 fields)
    local labels=(user nice system idle iowait irq softirq steal guest guest_nice)

    # Compute total
    local total=0
    for val in "${cpu_values[@]}"; do
        total=$((total + val))
    done

    # Print label=value format
    for i in "${!cpu_values[@]}"; do
        label=${labels[$i]:-field_$i} # fallback label if needed
        percent=$(echo "scale=2; ${cpu_values[$i]} * 100 / $total" | bc)
        send_metrics_to_statsd $percent "cpu.$label"
    done
}

main() {
    pid=$(get_process_id)
    cpu_core_count=$(get_cores)
    emit_load_avg_metrics $cpu_core_count
    emit_cpu_metrics
    emit_ctx_switching_metrics $pid
    emit_ctx_switching_rate_metrics $pid
}

# call main method
main
