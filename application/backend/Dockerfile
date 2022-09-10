FROM node:16

WORKDIR /usr/src/app
COPY api/package*.json ./

RUN npm install

COPY /api/* .

EXPOSE 8081

CMD [ "node", "server.js" ]