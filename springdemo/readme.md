# spring boot tutorial 
* https://www.youtube.com/watch?v=gJrjgg1KVL4
* maven central https://central.sonatype.com/

# run project by maven cli
* mvnw spring-boot:run

# using spring-boot-devtools
* go the settings of inteliJ
* -> build,execution,deployment -> compiler -> check build project automatically
* -> advanced setting -> check allow auto-make to start

# start project with different profile
* mvn spring-boot:run -Dspring-boot.run.profiles=qa

# start project by run jar
* java -jar ./target/springdemo-0.0.1-SNAPSHOT.jar --spring.profiles.active=qa
* this can be used in docker environment

# application.properties will override application.yml by default.

# swagger meta data: springdoc.swagger-ui.path=/swagger-ui.html