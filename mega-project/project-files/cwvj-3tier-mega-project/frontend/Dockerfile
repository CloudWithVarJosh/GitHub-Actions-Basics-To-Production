FROM nginx:1.31.6-alpine3.24-slim

# Update Alpine packages to include the latest security fixes.
RUN apk upgrade --no-cache

# Remove the default Nginx configuration.
RUN rm /etc/nginx/conf.d/default.conf

# Copy the application-specific Nginx configuration.
COPY nginx.conf /etc/nginx/nginx.conf

# Copy the validated frontend build artifact.
COPY dist /usr/share/nginx/html

# Prepare directories required by Nginx when running as a non-root user.
RUN chown -R nginx:nginx /usr/share/nginx/html \
    /var/cache/nginx \
    /var/log/nginx \
    /etc/nginx \
    && touch /tmp/nginx.pid \
    && chown nginx:nginx /tmp/nginx.pid

USER nginx

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]