# Use a lightweight Nginx image instead of Ubuntu
FROM nginx:alpine

# Remove default Nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom website to the container's web directory
COPY index.html /usr/share/nginx/html/index.html

# Expose the container's HTTP port
EXPOSE 80
