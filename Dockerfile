FROM nginx:alpine

# Copy your HTML page
COPY index.html /usr/share/nginx/html/index.html

# Copy the custom nginx config
COPY default.conf /etc/nginx/conf.d/default.conf

# Expose port 8888 (nginx will listen there inside the container)
EXPOSE 8888

CMD ["nginx", "-g", "daemon off;"]
