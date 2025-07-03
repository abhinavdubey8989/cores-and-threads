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
    # echo "$final_metric = $counter"

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

emit_thread_related_metrics() {
    json=$(curl -s "$BASE_URL/read/java.lang:type=Threading/ThreadCount,DaemonThreadCount,TotalStartedThreadCount")

    # Extract fields using jq
    current_thread_count=$(echo "$json" | jq -r '.value.ThreadCount')
    daemon_thread_count=$(echo "$json" | jq -r '.value.DaemonThreadCount')
    total_thread_started=$(echo "$json" | jq -r '.value.TotalStartedThreadCount')

    send_metrics_to_statsd $current_thread_count "jvm.thread.current_thread_count"
    send_metrics_to_statsd $daemon_thread_count "jvm.thread.daemon_thread_count"
    send_metrics_to_statsd $total_thread_started "jvm.thread.total_thread_started"
}

main() {
    emit_thread_related_metrics
    emit_heap_related_metrics
}

# call main method
main
