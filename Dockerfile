FROM maven:3.9.6-eclipse-temurin-21 AS build

WORKDIR /app
COPY . .
RUN mvn -B clean install

FROM eclipse-temurin:21-jre

WORKDIR /app
COPY --from=build /app/target/*.jar vibh_app.jar

ENTRYPOINT ["java", "-jar", "vibh_app.jar"]
