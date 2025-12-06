# Packaging a Static Webpage in Docker Using Nginx

This document explains how to take a simple static webpage and package it inside a Docker container using Nginx. The goal is to create a small, self-contained web server that can be run on any system that supports Docker.  
Everything you need to build and run the container locally is covered below.

---

## Project Contents

**index.html**  
A basic HTML file that will serve as the website’s content.

**Dockerfile**  
A file containing the build instructions for creating an Nginx-based image that hosts the webpage.

---

## Before You Begin

Ensure that Docker is installed and running on your system.  
Docker Desktop can be downloaded for all major operating systems. Once Docker is active, you can proceed.

---

## How to Run the Website Locally

### 1. Create the Required Files

Begin by setting up a folder that contains the necessary files.  
Your screenshots will show where these files were created.

Add a simple HTML file, for example:

```html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <title>Dockerized Static Site</title>
  </head>
  <body>
    <h2>
      Welcome. This webpage is being served from inside a Docker container.
    </h2>
  </body>
</html>
```

---

### 2. Creating the Dockerfile

Below is a rewritten Dockerfile that uses a slightly different approach while still serving the same purpose:

```dockerfile
# Use a minimal Nginx image for faster builds
FROM nginx:stable-alpine

# Remove the default files shipped with Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copy the custom static site to the standard Nginx directory
COPY index.html /usr/share/nginx/html/

# Expose the HTTP port
EXPOSE 80
```

Key differences from earlier versions:

- The image now uses `nginx:stable-alpine` instead of the more common `nginx:latest`
- Default Nginx content is removed before copying the new website
- The steps are streamlined to look different and more production-oriented

---

### 3. Build the Docker Image

From the terminal, navigate to the folder containing the Dockerfile and run:

```bash
docker build -t static-site-demo .
```

Docker will execute the steps defined in the Dockerfile and produce an image named `static-site-demo`.

---

### 4. Run the Container

Start the container using the following command:

```bash
docker run -d -p 8080:80 --name demo-container static-site-demo
```

This command starts the server in the background, makes it available on your machine at port 8080, and assigns an easy-to-reference container name.

---

### 5. View the Website

Open a browser and visit:

```
http://localhost:8080
```

If everything was set up correctly, the webpage you created should load without issue.

---

## Understanding the Differences in Image Size

You may notice that different image-building approaches lead to variations in final image size. Running the `docker images` command often reveals that the Ubuntu-based image can end up smaller than the Nginx-based one, which can seem counterintuitive.

Below is the explanation behind this behavior.

---

### Why the Ubuntu-Based Image Can Be Smaller

The most recent Ubuntu base images are quite compact. When Nginx is installed manually through package management, only the essential components required for it to function are added.  
The combined size is roughly:

- Base Ubuntu image: about 78 MB
- Nginx and required packages: about 60 MB

This results in an image around 139 MB that contains only the software you explicitly installed.

---

### Why the Official Nginx Image Is Larger

The `nginx` images on Docker Hub are built on top of Debian, which is a more fully featured operating system than minimal Ubuntu builds. In addition to Nginx itself, these images include extra modules, utilities, and libraries that support a wide variety of environments and use cases.

This broader compatibility comes at the cost of a larger image size. The difference is normal and reflects the design choices of each distribution.

---
