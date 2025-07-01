

# [Local developement]
- `CONFIG_FILE=/Users/abhinav.dubey/Documents/ad/cores-and-threads/resources/config-local.edn lein repl :headless  `


# [Prod]
- `CONFIG_FILE=config-prod.edn lein repl :headless`



# [Create JAR]
- `lein uberjar` -> will create 2 JARs use the one : `target/ubserjar/core-and-threads-0.1.0.jar`
- run JAR : 

CONFIG_FILE=config-prod.edn \
java -javaagent:/Users/abhinav.dubey/Documents/ad/cores-and-threads/devops/static/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0 \
     -jar target/uberjar/cores-and-threads-0.1.0-standalone.jar
     

# [SCP-1]
scp -i \
/Users/abhinav.dubey/Documents/ad/aws-and-docker/0_secrets/aws_ad89.pem \
/Users/abhinav.dubey/Documents/ad/cores-and-threads/target/uberjar/cores-and-threads-0.1.0-standalone.jar \
ubuntu@13.233.112.165:/home/ubuntu

scp -i \
/Users/abhinav.dubey/Documents/ad/aws-and-docker/0_secrets/aws_ad89.pem \
/Users/abhinav.dubey/Documents/ad/cores-and-threads/resources/* \
ubuntu@13.233.112.165:/home/ubuntu/

CONFIG_FILE=config-prod.edn \
java -jar cores-and-threads-0.1.0-standalone.jar



# [SCP-2]
scp -i \
/Users/abhinav.dubey/Documents/ad/aws-and-docker/0_secrets/aws_ad89.pem \
/Users/abhinav.dubey/Documents/ad/cores-and-threads/target/uberjar/cores-and-threads-0.1.0-standalone.jar \
ubuntu@13.127.31.44:/home/ubuntu


scp -i \
/Users/abhinav.dubey/Documents/ad/aws-and-docker/0_secrets/aws_ad89.pem \
/Users/abhinav.dubey/Documents/ad/cores-and-threads/resources/* \
ubuntu@13.127.31.44:/home/ubuntu/


<!-- 
CONFIG_FILE=/home/ubuntu/assets/config-prod.edn \
java -javaagent:/home/ubuntu/assets/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0 \
-jar /home/ubuntu/assets/cores-and-threads-0.1.0-standalone.jar 
-->


Consider a clojure backend server whose : business logic is to spin up specified number of threads & each thread then finds square root of a very big number for specified number of times for specified duration (say 20 minutes)
Which is more of a CPU intensive task rather than I/O or memory intensive task

What i did : i compare key metrics like JVM thread count , JVM heap size, Machine's load average, along with application metrics : avg time taken to complete 1 task & number of such tasks done using statsd , graphite, grafana

my observation : Running the application on 8 cores had best results & on 4 cores the number of tasks done was lesser & time for each task increased & likewise for 2 core machine

I want to write a medium article for the above
suggest the high level topic to add

====