FROM openjdk:10-jre-slim


COPY build/libs/template-service.jar /jar/

# Service listening port
EXPOSE 7000/tcp

ENTRYPOINT ["java", "-jar", "/jar/template-service.jar"]
