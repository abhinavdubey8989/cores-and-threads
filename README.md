
# [Aim]
Analyse the impact of number of CPU cores on the throughput & latency of a multi-threaded application


# [Local developement]
- `CONFIG_FILE=/full/path/to/config-local.edn lein repl :headless`


# [Prod]
- `CONFIG_FILE=/full/path/to/config-prod.edn lein repl :headless`



# [Create JAR]
- `lein uberjar` -> will create 2 JARs use the `standalone` jar

# [Running the JAR]
CONFIG_FILE=/ful/path/to/config-prod.edn \
java -javaagent:/full/path/to/jolokia.jar=port=8778,host=0.0.0.0 \
     -jar /full/path/to/cores-and-threads-0.1.0-standalone.jar
