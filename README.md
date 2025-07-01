

# [Local developement]
- `CONFIG_FILE=config-local.edn lein repl :headless`


# [Prod]
- `CONFIG_FILE=config-prod.edn lein repl :headless`



# [Create JAR]
- `lein uberjar` -> will create 2 JARs use the one : `target/ubserjar/core-and-threads-0.1.0.jar`
- run JAR : 

CONFIG_FILE=config-prod.edn \
java -javaagent:/Users/abhinav.dubey/Downloads/jolokia-jvm-1.6.2-agent.jar=port=8778,host=0.0.0.0 \
     -jar target/uberjar/cores-and-threads-0.1.0-standalone.jar
