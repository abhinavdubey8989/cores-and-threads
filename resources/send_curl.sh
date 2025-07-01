HOST=$1
PORT=$2
MACHINE_TYPE=$3
METRIC_PREFIX=$4
THREADS=$5
DURATION_MINUTES=$6
TIMES=$7
INPUT_NUM=$8

curl --location "http://$HOST:$PORT/api/foo-bar" \
    --header 'Accept: text/html,application/json,application/xml' \
    --header 'Content-Type: application/json' \
    --data '{
        "machine_type": "'"$MACHINE_TYPE"'",
        "metric_prefix": "'"$METRIC_PREFIX"'",
        "duration_minutes": '"$DURATION_MINUTES"',
        "threads": '"$THREADS"',
        "times": '"$TIMES"',
        "input_num": '"$INPUT_NUM"'
    }'
