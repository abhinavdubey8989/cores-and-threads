THREADS=5
DURATION_MINUTES=1
TIMES=10000
NUMBER=10000
METRIC_PREFIX=""

# Threads, Duration, Times, Number
./send_curl.sh "ec2.java-1" "3020" "$METRIC_PREFIX" \
    $THREADS $DURATION_MINUTES $TIMES $NUMBER

./send_curl.sh "ec2.java-2" "3020" "$METRIC_PREFIX" \
    $THREADS $DURATION_MINUTES $TIMES $NUMBER

./send_curl.sh "ec2.java-3" "3020" "$METRIC_PREFIX" \
    $THREADS $DURATION_MINUTES $TIMES $NUMBER

# for local testing
# ./send_curl.sh "localhost" "3020" "$METRIC_PREFIX" \
#     $THREADS $DURATION_MINUTES $TIMES $NUMBER

echo
echo
