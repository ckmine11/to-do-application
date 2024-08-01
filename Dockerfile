 FROM node:14-alpine
 RUN apk add --no-cache python3 g++ make
 RUN chmod u+x /trivy/fanal
 WORKDIR /app
 COPY . .
 RUN yarn install --production
 CMD ["node", "src/index.js"]
 EXPOSE 3000
