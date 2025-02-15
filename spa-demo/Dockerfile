FROM node:12-alpine

RUN mkdir -p /data/app && \
    mkdir -p /data/log/app && \
    chown -R node:node /data/app && \
    chown -R node:node /data/log/app
WORKDIR /data/app
USER node

COPY --chown=node:node .  /data/app/

EXPOSE 4000
CMD printenv; node ./server/server.js