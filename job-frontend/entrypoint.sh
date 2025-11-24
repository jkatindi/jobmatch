#!/bin/sh

# Render nginx.conf from template using REMOTE_HOST
if [ -f /etc/nginx/templates/nginx.conf.template ]; then
  envsubst '$REMOTE_HOST' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf
fi

# If present, render frontend runtime env file (optional)
if [ -f /usr/share/nginx/html/assets/env.template.js ]; then
  envsubst '$REMOTE_HOST' < /usr/share/nginx/html/assets/env.template.js > /usr/share/nginx/html/assets/env.js
fi

exit 0
