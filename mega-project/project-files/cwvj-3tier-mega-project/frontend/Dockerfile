# Use the official Nginx image with Alpine 3.24 as the base image.
FROM nginx:1.31.6-alpine3.24-slim

# Upgrade installed Alpine packages to pick up available package and security updates.
RUN apk upgrade --no-cache

# Remove the default Nginx server configuration.
RUN rm /etc/nginx/conf.d/default.conf

# Copy our application-specific Nginx configuration into the image.
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the validated frontend build artifact into Nginx's static content directory.
COPY dist /usr/share/nginx/html

# Assign the required directory and PID file ownership for non-root Nginx execution.
RUN chown -R nginx:nginx /var/cache/nginx \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid

# Run Nginx as a non-root user.
USER nginx

# Document the port on which Nginx listens inside the container.
EXPOSE 8080

# Start Nginx in the foreground so the container remains running.
CMD ["nginx", "-g", "daemon off;"]