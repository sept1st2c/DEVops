#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# 1. Update packages and install Docker
apt-get update
apt-get install -y docker.io apt-transport-https ca-certificates curl software-properties-common

# 2. Start and enable Docker
systemctl start docker
systemctl enable docker

# 3. Create directories for NGINX config and certs
mkdir -p /etc/nginx/certs
mkdir -p /var/www/html

# # 4. Generate self-signed SSL certificate (Task 7)
# openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
#     -keyout /etc/nginx/certs/key.pem \
#     -out /etc/nginx/certs/cert.pem \
#     -subj "/C=US/ST=California/L=SanFrancisco/O=MyWebApp/CN=nginx.example.com"

# 4. Create SSL certificate files from Terraform variables
echo "${nginx_cert_pem}" > /etc/nginx/certs/cert.pem
echo "${nginx_key_pem}" > /etc/nginx/certs/key.pem

# 5. Create a basic index.html page
echo "<h1>Hello from your NGINX container on Azure!</h1>" > /var/www/html/index.html

# 6. Create the NGINX configuration file (Task 7)
cat <<EOF > /etc/nginx/nginx.conf
events {}
http {
    server {
        listen 80;
        server_name _;
        # Redirect all HTTP to HTTPS
        return 301 https://\$host\$request_uri;
    }

    server {
        listen 443 ssl;
        server_name _;

        ssl_certificate /etc/nginx/certs/cert.pem;
        ssl_certificate_key /etc/nginx/certs/key.pem;

        location / {
            root /var/www/html;
            index index.html;
        }
    }
}
EOF

# 7. Run the NGINX container (Task 7)
# We map our custom config, certs, and HTML page into the container
docker run -d --name nginx-app \
    -p 80:80 \
    -p 443:443 \
    -v /etc/nginx/nginx.conf:/etc/nginx/nginx.conf \
    -v /etc/nginx/certs:/etc/nginx/certs \
    -v /var/www/html:/var/www/html \
    --restart always \
    nginx:latest

echo "✅ VM setup and NGINX container launch complete."