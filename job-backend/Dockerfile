FROM   maven   AS  build
WORKDIR /app
COPY  pom.xml  .
# Download dependencies (only runs if pom.xml changes)
RUN mvn dependency:go-offline -B
# Copy the rest of the application source code.
COPY src ./src
# Build the Spring Boot application (creates a JAR file in 'target').
RUN mvn clean package

FROM  eclipse-temurin:21-jdk-alpine
# Set working directory
WORKDIR /app
# Install curl for healthcheck
RUN apk add --no-cache curl
# Copy the built JAR from the 'build' stage.
# Replace 'your-application-name-1.0.0.jar' with your actual generated JAR file name
COPY  --from=build  /app/target/job-backend*.jar /app.jar
CMD ["java","-jar","/app.jar","--spring.profiles.active=prod"]
EXPOSE 8084