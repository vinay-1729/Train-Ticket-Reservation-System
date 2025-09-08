# 1. Build stage – compile WAR
FROM maven:3.8.8-openjdk-8 AS builder
WORKDIR /app

# Copy project files
COPY pom.xml .
COPY src ./src
COPY WebContent ./WebContent

# Package the WAR and fetch webapp-runner.jar
RUN mvn clean package

# 2. Runtime stage
FROM openjdk:8-jre-slim
WORKDIR /app

# Copy outputs from builder
COPY --from=builder /app/target/TrainBook-1.0.0-SNAPSHOT.war app.war
COPY --from=builder /app/target/dependency/webapp-runner.jar webapp-runner.jar

# Expose port 8090
EXPOSE 8090

# Run using webapp-runner on port 8090
CMD ["java", "-jar", "webapp-runner.jar", "--port", "8090", "app.war"]

