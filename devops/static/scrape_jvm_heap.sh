#!/bin/bash

source /home/ubuntu/assets/env_file.env
TARGET_HOST=$1
TARGET_PORT=$2
BASE_URL="http://$TARGET_HOST:$TARGET_PORT/jolokia"

# hostname as metric prefix
HOSTNAME=$(hostname)

send_metrics_to_statsd() {
    local counter=$1
    local metric_suffix=$2
    local final_metric="$HOSTNAME.$metric_suffix"

    # print to console
    echo "$final_metric = $counter"

    # send metric command
    echo "$final_metric:$counter|c" | nc -w 1 -u $STATSD_HOST $STATSD_PORT
}

emit_heap_related_metrics() {
    json=$(curl -s "$BASE_URL/read/java.lang:type=Memory/HeapMemoryUsage")

    # Extract stats using jq
    initial_heap_size=$(echo "$json" | jq -r '.value.init')
    committed_heap_size=$(echo "$json" | jq -r '.value.committed')
    max_heap_size=$(echo "$json" | jq -r '.value.max')
    current_heap_size=$(echo "$json" | jq -r '.value.used')

    send_metrics_to_statsd $initial_heap_size "jvm.heap.initial_heap_size"
    send_metrics_to_statsd $committed_heap_size "jvm.heap.committed_heap_size"
    send_metrics_to_statsd $max_heap_size "jvm.heap.max_heap_size"
    send_metrics_to_statsd $current_heap_size "jvm.heap.current_heap_size"
}

main() {
    start_time=$(date +%s)
    emit_heap_related_metrics
    end_time=$(date +%s)
    duration=$((end_time - start_time))
    echo "Execution time : [$duration] seconds"
}

# call main method
main
