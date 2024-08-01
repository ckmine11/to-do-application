# syntax=docker/dockerfile:1
 FROM node:12-alpine3.14
 RUN apk add --no-cache python3 g++ make
 WORKDIR /app
 COPY . .
 RUN yarn install --production
 CMD ["node", "src/index.js"]
 EXPOSE 3000
