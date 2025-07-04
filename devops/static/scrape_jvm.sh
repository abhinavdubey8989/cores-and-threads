#!/bin/bash

source /home/ubuntu/assets/env_file.env
TARGET_HOST=$1
TARGET_PORT=$2
BASE_URL="http://$TARGET_HOST:$TARGET_PORT"

# hostname as metric prefix
HOSTNAME=$1

send_metrics_to_statsd() {
    local counter=$1
    local metric_suffix=$2
    local final_metric="$HOSTNAME.$metric_suffix"

    # print to console
    # echo "$final_metric = $counter"

    # send gauge metric command
    echo "$final_metric:$counter|g" | nc -w 1 -u $STATSD_HOST $STATSD_PORT
}


to_megabyte() {
    # Convert bytes to MB (ceiling)
    converted_val=$(awk -v bytes="$1" 'BEGIN { printf "%d", (bytes + (1024*1024 - 1)) / (1024 * 1024) }')
    echo "$converted_val"
}


emit_heap_related_metrics() {
    json=$(curl -s "$BASE_URL/jolokia/read/java.lang:type=Memory/HeapMemoryUsage")

    # Extract stats using jq
    initial_heap_size=$(echo "$json" | jq -r '.value.init')
    committed_heap_size=$(echo "$json" | jq -r '.value.committed')
    max_heap_size=$(echo "$json" | jq -r '.value.max')
    current_heap_size=$(echo "$json" | jq -r '.value.used')

    initial_gb=$(to_megabyte "$initial_heap_size")
    committed_gb=$(to_megabyte "$committed_heap_size")
    max_gb=$(to_megabyte "$max_heap_size")
    current_gb=$(to_megabyte "$current_heap_size")

    send_metrics_to_statsd $initial_gb "jvm.heap.initial_heap_size"
    send_metrics_to_statsd $committed_gb "jvm.heap.committed_heap_size"
    send_metrics_to_statsd $max_gb "jvm.heap.max_heap_size"
    send_metrics_to_statsd $current_gb "jvm.heap.current_heap_size"
}

emit_thread_related_metrics() {
    json=$(curl -s "$BASE_URL/jolokia/read/java.lang:type=Threading/ThreadCount,DaemonThreadCount,TotalStartedThreadCount")

    # Extract fields using jq
    current_thread_count=$(echo "$json" | jq -r '.value.ThreadCount')
    daemon_thread_count=$(echo "$json" | jq -r '.value.DaemonThreadCount')
    total_thread_started=$(echo "$json" | jq -r '.value.TotalStartedThreadCount')

    send_metrics_to_statsd $current_thread_count "jvm.thread.current_thread_count"
    send_metrics_to_statsd $daemon_thread_count "jvm.thread.daemon_thread_count"
    send_metrics_to_statsd $total_thread_started "jvm.thread.total_thread_started"
}

main() {

    # start_time=$(date +%s)
    # ===
    emit_thread_related_metrics &
    pid1=$!

    emit_heap_related_metrics &
    pid2=$!

    wait $pid1
    wait $pid2
    # ===
    # end_time=$(date +%s)
    # duration=$((end_time - start_time))
    # echo "Execution time : [$duration] seconds"
}

# call main method
main
