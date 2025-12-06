FROM nginx:alpine

# remove default configuration
RUN rm /etc/nginx/conf.d/default.conf

# copy custom configuration and static files
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html /usr/share/nginx/html/index.html

EXPOSE 80
