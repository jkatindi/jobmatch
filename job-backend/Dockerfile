FROM  ibmjava
VOLUME /tmp
ADD ./target/offer-service*.jar  /app.jar
CMD ["java","-jar","/app.jar","--spring.profiles.active=prod"]
EXPOSE 8084