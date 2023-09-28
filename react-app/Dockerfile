# Stage 1: Build the React application
FROM node:14 as builder

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY ./package*.json ./

# Install the application dependencies
RUN npm install

# Copy the rest of the application code to the container
COPY . .

# Build the React application
RUN npm run build

# Stage 2: Serve the built React application using Nginx
FROM nginx:alpine

# Remove the default Nginx configuration file
RUN rm -rf /etc/nginx/conf.d/default.conf

# Copy the custom Nginx configuration to the container
COPY nginx/nginx.conf /etc/nginx/conf.d

# Copy the built React application from the builder stage to the Nginx web root
COPY --from=builder /app/build /usr/share/nginx/html

# Expose port 80 to the outside world (Nginx default)
EXPOSE 80

# Start Nginx when the container starts
CMD ["nginx", "-g", "daemon off;"]