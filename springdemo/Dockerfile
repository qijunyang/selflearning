FROM maven:3.9.9-amazoncorretto-17-alpine AS builder
WORKDIR /app
ADD . ./
RUN mvn clean package -DskipTests=true

FROM amazoncorretto:17-alpine
COPY --from=builder /app/target/springdemo-0.0.1-SNAPSHOT.jar /app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app.jar"]