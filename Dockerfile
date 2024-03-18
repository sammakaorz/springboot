FROM maven:3.9.6-eclipse-temurin-17 as build
WORKDIR /app
COPY . .
RUN mvn clean package

FROM eclipse-temurin:17.0.6_10-jdk
WORKDIR /app
COPY --from=build /app/target/springboot-0.0.1-SNAPSHOT.jar /app/
EXPOSE 8080
CMD [ "java", "-jar", "springboot-0.0.1-SNAPSHOT.jar" ]
