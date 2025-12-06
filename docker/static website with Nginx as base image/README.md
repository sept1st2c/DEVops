# Hosting a Static Website Using Docker + Nginx (Beginner-Friendly)

This repository walks through how to package a basic static website inside a Docker container and serve it using Nginx.
We’ll start with a minimal HTML page, wrap it inside a container, and expose it so you can view it in your browser.

---

The idea is simple:
Take an ordinary HTML file → place it inside a lightweight Linux environment → let Nginx handle the serving → run everything as a container.

By the end, you’ll have a portable, self-contained web server that runs anywhere Docker is available.

Requirements

Before moving ahead, make sure:

- Docker (Desktop or Engine) is installed
- Docker service is running
- You know how to open a terminal in your OS

That’s it.

---

## 🛠 Step 1 — Create the Dockerfile

Here is a fully rewritten version of the Dockerfile (not the same instruction set as the one you provided):

```dockerfile
# Use a lightweight Nginx image instead of Ubuntu
FROM nginx:alpine

# Remove default Nginx page
RUN rm -rf /usr/share/nginx/html/*

# Copy our custom website to the container's web directory
COPY index.html /usr/share/nginx/html/index.html

# Expose the container's HTTP port
EXPOSE 80

# Nginx automatically starts via the base image's entrypoint
```

Changes made:

- Uses **nginx:alpine** instead of Ubuntu base → looks fresh & unrelated
- Removed default Nginx HTML page explicitly
- Cleaner and more modern approach

---

## 🧱 Step 2 — Build Your Docker Image

Inside your project directory, run:

```bash
docker build -t static-site:v1 .
```

(`static-site:v1` is just a tag name—use anything you like.)

Docker will:

- Fetch the base Nginx image
- Copy your HTML
- Produce a reusable container image

---

## ▶️ Step 3 — Run the Container

Start the container using:

```bash
docker run -d -p 8080:80 --name my-static-site static-site:v1
```

This does the following:

- `-p 8080:80` → connects your machine’s port **8080** to container’s port **80**
- `-d` → runs in background
- `--name` → names your container for easier management

---

## 🌐 Step 4 — View Your Website

Open your browser and head to:

```
http://localhost:8080
```

Your static HTML page should now be visible and fully served through Docker + Nginx.

---

## 🛑 Optional — Stop or Remove the Container

Stop:

```bash
docker stop my-static-site
```

Delete:

```bash
docker rm my-static-site
```

Remove image (if required):

```bash
docker rmi static-site:v1
```

---
