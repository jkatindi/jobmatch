FROM  eclipse-temurin:21-jdk-alpine
# Set working directory
WORKDIR /app
# Copy the built JAR from the 'build' stage.
# Replace 'your-application-name-1.0.0.jar' with your actual generated JAR file name
COPY  ./target/job-backend*.jar /app.jar
CMD ["java","-jar","/app.jar","--spring.profiles.active=prod"]
EXPOSE 8084