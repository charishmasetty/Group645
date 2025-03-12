# Use the official Nginx image
FROM nginx:latest

# Copy Survey.html to Nginx default root directory
COPY index.html /usr/share/nginx/html/index.html

# Expose port 80 to allow access
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
