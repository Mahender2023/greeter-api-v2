# --- STAGE 1: Build the application ---
# Use a Maven image that includes JDK 21 to build our project.
FROM maven:3.9-eclipse-temurin-21-focal AS build

# Set the working directory inside the container.
WORKDIR /app

# Copy the pom.xml file first. Docker is smart and will only re-download
# dependencies if this file changes, speeding up future builds.
COPY pom.xml .

# Copy the rest of our source code.
COPY src ./src

# Run the Maven command to compile the code and package it into a .jar file.
# -DskipTests makes the build faster.
RUN mvn package -DskipTests

# --- STAGE 2: Create the final, lightweight runtime image ---
# Use a slim JRE (Java Runtime Environment) image. It's much smaller
# than a full JDK, making our final container more efficient.
FROM openjdk:21-slim

# Set the working directory.
WORKDIR /app

# Copy ONLY the compiled .jar file from the 'build' stage into this final image.
COPY --from=build /app/target/greeter-api-v2-*.jar app.jar

# Tell Docker that our application will listen on port 8080.
EXPOSE 8080

# The command that will be run when the container starts.
ENTRYPOINT ["java", "-jar", "app.jar"]