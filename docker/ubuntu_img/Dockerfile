# Use a minimal Nginx image for faster builds
FROM nginx:stable-alpine

# Remove the default files shipped with Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy the custom static site to the standard Nginx directory
COPY index.html /usr/share/nginx/html/

# Expose the HTTP port
EXPOSE 80
