
# threads : 1, 2, 4, 8, 10
# with 1 thread we just check how much time it takes to execute do-work fn once -> set print-percent to 100 here

# Sqr-root   looptimes     time-taken by 1 thead
# 10^15      10^6 x 10     0.098 -> 0.1 seconds
# 10^15      10^6 x 15     0.14  -> 0.15 seconds


THREADS=8
DURATION_MINUTES=10
METRIC_PREFIX="work"
PRINT_PERCENT=1

PORT="3020"
SQR_ROOT_NUMBER=$((1000 * 1000 * 1000 * 1000 * 1000))

# below 2 vars are only for LOOP_LIST creation
NUM_OF_ELEMENTS_IN_LOOP_LIST=10
EACH_ELEMENT_VALUE_IN_LOOP_LIST=1000000


build_loop_list() {
    local num_of_elements_in_loop_list=$1
    local each_element_value=$2
    local list=()

    for ((i = 0; i < num_of_elements_in_loop_list; i++)); do
        list+=("$each_element_value")
    done

    # Join list into JSON array format
    local json_list=$(printf '%s,' "${list[@]}" | sed 's/,$//')
    echo "[$json_list]"
}


send_curl() {
    # this fn invoke the adjacent script to invoke the cULR
    local target_host=$1
    local loop_list=$(build_loop_list "$NUM_OF_ELEMENTS_IN_LOOP_LIST" "$EACH_ELEMENT_VALUE_IN_LOOP_LIST")

    ./send_curl.sh "$target_host" "$PORT" "$METRIC_PREFIX" \
        $THREADS $DURATION_MINUTES \
        $loop_list $SQR_ROOT_NUMBER $PRINT_PERCENT

    echo
}

send_curl "cores-2"
send_curl "cores-4"
send_curl "cores-8"

# for local testing
# send_curl "localhost"
