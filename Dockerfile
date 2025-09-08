# 1. Build stage – compile WAR
FROM maven:3.9.3-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

RUN mvn clean package

# 2. Runtime stage
FROM eclipse-temurin:17-jre
WORKDIR /app

COPY --from=builder /app/target/TrainBook-1.0.0-SNAPSHOT.war app.war
COPY --from=builder /app/target/dependency/webapp-runner.jar webapp-runner.jar

EXPOSE 8090

CMD ["java", "-jar", "webapp-runner.jar", "--port", "8090", "app.war"]
