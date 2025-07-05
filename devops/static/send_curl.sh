HOST=$1
PORT=$2
METRIC_PREFIX=$3
THREADS=$4
DURATION_MINUTES=$5
LOOP_LIST=$6
INPUT_NUM=$7
PRINT_PERCENT=$8


curl --location "http://$HOST:$PORT/api/foo-bar" \
    --header 'Accept: text/html,application/json,application/xml' \
    --header 'Content-Type: application/json' \
    --data '{
        "metric_prefix": "'"$METRIC_PREFIX"'",
        "duration_minutes": '"$DURATION_MINUTES"',
        "threads": '"$THREADS"',
        "loop_list": '"$LOOP_LIST"',
        "sqr_root_num": '"$INPUT_NUM"',
        "print_percent": '"$PRINT_PERCENT"'
    }'
