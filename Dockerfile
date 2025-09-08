# 1. Build stage – compile WAR
FROM maven:3.8.7-openjdk-8 AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

RUN mvn clean package

# 2. Runtime stage
FROM openjdk:8-jre-slim
WORKDIR /app

COPY --from=builder /app/target/TrainBook-1.0.0-SNAPSHOT.war app.war
COPY --from=builder /app/target/dependency/webapp-runner.jar webapp-runner.jar

EXPOSE 8080
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8080", "app.war"]
