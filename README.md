

# [Local developement]
- `CONFIG_FILE=config-local.edn lein repl :headless`


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
CONFIG_FILE=config-prod.edn \
java -javaagent:/home/ubuntu/assets/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0 \
-jar /home/ubuntu/assets/cores-and-threads-0.1.0-standalone.jar 
-->