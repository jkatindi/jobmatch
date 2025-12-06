#!/bin/bash


# Run envsubst to replace placeholders in environment.prod.ts with actual environment variable values
#envsubst < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js
envsubst  '$REMOTE_HOST' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf
# Start the Angular application
exec "$@"
