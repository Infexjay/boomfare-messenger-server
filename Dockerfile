# Use Node.js 18 as the base image
FROM node:18-slim

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

# Expose the port the app will run on.
# Koyeb automatically maps this to 80/443.
EXPOSE 3000

# The command to start the app
CMD [ "npm", "start" ]
