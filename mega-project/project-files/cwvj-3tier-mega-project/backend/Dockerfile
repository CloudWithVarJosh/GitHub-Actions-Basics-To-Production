# Use the Eclipse Temurin Java 21 JRE based on Ubuntu 24.04 LTS.
FROM eclipse-temurin:21-jre-noble

# Add OCI metadata to identify and describe the container image.
LABEL org.opencontainers.image.title="CWVJ User Management API" \
      org.opencontainers.image.description="Spring Boot backend for the Cloud With VarJosh GitHub Actions Mega Project" \
      org.opencontainers.image.vendor="Cloud With VarJosh"

# Create a dedicated system group and non-root user with fixed numeric IDs.
RUN groupadd --system --gid 10001 appuser \
    && useradd --system \
       --uid 10001 \
       --gid 10001 \
       --no-create-home \
       --shell /usr/sbin/nologin \
       appuser

# Set /app as the working directory inside the container.
WORKDIR /app

# Copy the application JAR into the image and assign ownership to UID 10001 and GID 10001.
COPY --chown=10001:10001 user-management-api.jar app.jar

# Run the application using the dedicated non-root user and group.
USER 10001:10001

# Document the port on which the Spring Boot application listens.
EXPOSE 8080

# Start the Spring Boot application directly using the Java runtime.
ENTRYPOINT ["java", "-jar", "app.jar"]