# Use Node.js 18 as the base image
FROM node:18-slim

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

# Expose the port the app will run on.
# Koyeb automatically maps this to 80/443.
EXPOSE 3000

# The command to start the app.
CMD [ "npm", "start" ]
