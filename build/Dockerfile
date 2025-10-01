FROM n8nio/n8n:1.112.6

# Install bash for script execution
USER root
RUN apk add --no-cache bash

USER node

# Create workflows directory
RUN mkdir -p /home/node/workflows

# Copy entrypoint script
COPY --chown=node:node entrypoint.sh /home/node/entrypoint.sh
RUN chmod +x /home/node/entrypoint.sh

ENTRYPOINT ["/home/node/entrypoint.sh"]
