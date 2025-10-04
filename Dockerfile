# Use Node 16 as base image (matches the pipeline agent)
FROM node:16

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Copy app code
COPY . .

# Expose the port the app runs on (from app.js)
EXPOSE 8081

# Start the app
CMD ["node", "app.js"]