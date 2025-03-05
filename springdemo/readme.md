# MarkDown syntax
- https://www.markdownguide.org/basic-syntax/

# spring boot tutorial
- Tutorial Video https://www.youtube.com/watch?v=gJrjgg1KVL4
- Tutorial Doc https://spring.io/projects/spring-boot

# Spring boot controller router example
- https://howtodoinjava.com/spring-mvc/controller-getmapping-postmapping/

# JPA
- https://docs.spring.io/spring-data/jpa/reference/jpa.html
- https://docs.spring.io/spring-data/jpa/reference/jpa/query-methods.html

# Spring transaction
- https://javabetter.cn/springboot/transaction.html#%E4%BA%8B%E5%8A%A1%E4%BC%A0%E6%92%AD%E8%A1%8C%E4%B8%BA

# Log back
- https://logback.qos.ch/manual/layouts.html

# Maven Central
- https://central.sonatype.com/

# Run project by maven cli
- `mvnw spring-boot:run`

# Using spring-boot-devtools
- go the settings of inteliJ
- -> build,execution,deployment -> compiler -> check build project automatically
- -> advanced setting -> check allow auto-make to start

# Start project with different profile
- `mvn spring-boot:run -Dspring-boot.run.profiles=qa`

# Start project by run jar with different profile
- `java -jar ./target/springdemo-0.0.1-SNAPSHOT.jar --spring.profiles.active=qa`
- this can be used in docker environment

# Small Knowledge
- application.properties will override application.**yml** by default.
- swagger meta data: springdoc.swagger-ui.path=/swagger-ui.html
