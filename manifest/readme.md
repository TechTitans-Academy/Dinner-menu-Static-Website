# Dinner Menu – Static Website (Docker + Nginx)

A simple static web page that displays a **Dinner Menu** on a full-screen background image. The site is served via [Nginx](https://nginx.org/) inside a Docker container.


## 📂 Project Structure
```
.
├── index.html # Dinner Menu page
├── default.conf # Custom Nginx configuration (listens on 8888)
└── Dockerfile # Docker image definition
```

## 🚀 Quick Start

### 1️⃣ Build the Docker image

```
docker build -t dinner-menu .
```

### 2️⃣ Run the container
```
docker run -d -p 8888:8888 --name dinner dinner-menu
```

Open your browser at http://localhost:8888

### Configuration

<b>Nginx Port:</b> The site is served by Nginx inside the container on port 8888. (See default.conf.)

### HTML Location:
Nginx serves files from /usr/share/nginx/html. Our index.html is copied there during the build.

### Development Tips
To test the page quickly without Docker:
```
python3 -m http.server 8888
```
Then visit http://localhost:8888

### To update the menu:

- Edit index.html.
- Rebuild the image:
```
docker build -t dinner-menu .
docker restart dinner

```
