# Use Node.js version 16 as the base image
FROM node:16

# Set the working directory inside the container to /app
WORKDIR /app

# Copy package.json and package-lock.json (if exists) to the working directory
COPY package*.json ./

# Install dependencies defined in package.json
RUN npm install

# Copy all remaining project files to the working directory
COPY . .

# Expose port 8080 to allow external access to the application
EXPOSE 8080

# Define the command to run the application
CMD ["npm", "start"]