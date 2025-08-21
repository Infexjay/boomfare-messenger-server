# Use Node.js 18
FROM node:18-slim

# Create app directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy source code
COPY . .

# Expose the port
EXPOSE 3000

# Start the server
CMD [ "npm", "start" ]
