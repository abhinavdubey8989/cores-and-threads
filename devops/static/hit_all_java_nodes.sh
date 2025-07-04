# ./send_request "1.1.1.1" "2000" "t2.micro" "my-metric" 2

# Threads, Duration, Times, Number
./send_curl.sh "ec2.java-1" "3020" "" \
    10 2 1000000000 100000

# Threads, Duration, Times, Number
./send_curl.sh "ec2.java-2" "3020" "" \
    10 2 1000000000 100000

# Threads, Duration, Times, Number
./send_curl.sh "ec2.java-3" "3020" "" \
    10 2 1000000000 100000
