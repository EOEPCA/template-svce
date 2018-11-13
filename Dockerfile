FROM openjdk:10-jre-slim


COPY build/libs/catalogue-service.jar /jar/

# Service listening port
EXPOSE 7000/tcp

ENTRYPOINT ["java", "-jar", "/jar/catalogue-service.jar"]