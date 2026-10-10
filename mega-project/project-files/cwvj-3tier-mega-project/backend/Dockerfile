FROM eclipse-temurin:21-jre

LABEL org.opencontainers.image.title="CWVJ User Management API" \
      org.opencontainers.image.description="Spring Boot backend for the Cloud With VarJosh GitHub Actions Mega Project" \
      org.opencontainers.image.vendor="Cloud With VarJosh"

RUN useradd --system --create-home --shell /usr/sbin/nologin appuser

WORKDIR /app

COPY user-management-api.jar app.jar

RUN chown appuser:appuser app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]