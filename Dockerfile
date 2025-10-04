FROM node:16
RUN apt-get update && apt-get install -y docker.io
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 8081
CMD ["npm", "start"]