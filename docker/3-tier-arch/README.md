# Messages Application – Containerized 3-Tier Deployment with Docker and Nginx

This project demonstrates how to deploy a complete multi-tier messages application using Docker.
The architecture separates responsibilities into independent containers, allowing the system to be modular, scalable, and easy to maintain.

The application is built using four layers:

1. **Database Layer** – MongoDB container providing persistent storage.
2. **Application Layer** – Node.js/Express API responsible for business logic and database access.
3. **Proxy/Web Layer** – Nginx container serving the client and forwarding API traffic to the backend.
4. **Client Layer** – A simple HTML and JavaScript interface running inside the browser.

Together, these components form a functional end-to-end messages system that can be deployed entirely through Docker.

---

## Project Structure

```
messages-app/
├── docker-compose.yml
├── backend/
│   ├── Dockerfile
│   ├── package.json
│   └── index.js
└── nginx/
    ├── Dockerfile
    ├── nginx.conf
    └── index.html
```

Each component is isolated and packaged as its own container, following best practices for multi-service applications.

---

## How the Architecture Works

### MongoDB (Database Tier)

The MongoDB container stores all messages.
The backend connects to it using a network alias defined in Docker Compose.

### Node.js Backend (Application Tier)

The backend provides two API endpoints:

- `GET /api/messages` to retrieve all stored messages
- `POST /api/messages` to insert a new message

The service interacts with MongoDB and exposes port 5000 internally.

### Nginx (Proxy and Web Layer)

Nginx performs two responsibilities:

- Serves the static client (`index.html`)
- Forwards all requests starting with `/api/` to the backend service

This setup cleanly separates UI rendering and application logic.

### HTML/JavaScript Client (Frontend)

The browser loads the static page directly from Nginx and communicates with the backend using fetch calls to `/api/messages`.

---

## How to Run the Application

From the root project folder:

```bash
docker-compose up --build
```

Once all services are running, open a browser and navigate to:

```
http://localhost:8080
```

You can submit a message using the form, and all stored messages will be displayed beneath it.

---

## Stopping the Application

To stop the containers:

```bash
docker-compose down
```

This shuts down all services while preserving MongoDB data through its volume.

---

multi-stage builds.
