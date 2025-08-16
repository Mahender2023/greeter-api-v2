# --- STAGE 1: Build the application ---
# Use a well-known, stable Maven image that includes JDK 17
FROM maven:3.9-eclipse-temurin-17-focal AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy the pom.xml file first to leverage Docker layer caching
COPY pom.xml .

# Copy the rest of our source code.
COPY src ./src

# Run the Maven command to compile the code and package it into a .jar file.
RUN mvn package -DskipTests

# --- STAGE 2: Create the final, lightweight runtime image ---
# Use a slim JRE image for Java 17
FROM openjdk:17-slim

# Set the working directory.
WORKDIR /app

# Copy ONLY the compiled .jar file from the 'build' stage into this final image.
COPY --from=build /app/target/greeter-api-v2-*.jar app.jar

# Tell Docker that our application will listen on port 8080.
EXPOSE 8080

# The command that will be run when the container starts.
ENTRYPOINT ["java", "-jar", "app.jar"]