# Use Node.js 18 as the base image
FROM node:18-slim

feat/koyeb-deployment
# The base image already includes a non-root 'node' user.
# We'll use this user to run our application.
WORKDIR /app

# Copy package files and set their ownership to the 'node' user.
COPY --chown=node:node package*.json ./

# Switch to the non-root 'node' user.
USER node

# Install only production dependencies.
# This runs as the 'node' user.
RUN npm ci --only=production

# Copy the rest of the application source code.
# These files will also be owned by the 'node' user.
COPY . .
=======
# Create a non-root user and group for security
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 node

# Set the working directory in the container
WORKDIR /app

# Copy package files and install dependencies
# Use --chown to set ownership to the new user immediately
COPY --chown=node:nodejs package*.json ./

# Install only production dependencies using npm ci for reliability
RUN npm ci --only=production

# Copy the rest of the application source code
COPY --chown=node:nodejs . .

# Switch to the non-root user
USER node
 main

# Expose the port the app will run on.
# Koyeb automatically maps this to 80/443.
EXPOSE 3000

 feat/koyeb-deployment
# The command to start the app.
=======
# The command to start the app
 main
CMD [ "npm", "start" ]
