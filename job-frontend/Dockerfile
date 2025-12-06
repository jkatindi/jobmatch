# Multi-stage build for Angular application

# Stage 1: Build the Angular application
FROM node:22 AS builder
# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Run Angular compatibility compiler (ngcc)
# Copy the rest of the application
COPY . .
ARG REMOTE_HOST
ENV REMOTE_HOST=$REMOTE_HOST
# Build the application in production mode
RUN npm run build --configuration=production

# Stage 2: Serve the application with Nginx
FROM nginx:alpine

# Install gettext for envsubst, which is not available by default in the alpine image
RUN apk add --no-cache gettext
# Copy the built application from the build stage
COPY --from=builder /app/dist/job-offer-material /usr/share/nginx/html
# Copy Nginx configura

# Provide Nginx configuration template and entrypoint script for envsubst
RUN  mkdir -p /etc/nginx/templates
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template
COPY entrypoint.sh /docker-entrypoint.d/10-render-config.sh
RUN chmod +x /docker-entrypoint.d/10-render-config.sh
ENTRYPOINT ["sh","/docker-entrypoint.d/10-render-config.sh"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE   80



