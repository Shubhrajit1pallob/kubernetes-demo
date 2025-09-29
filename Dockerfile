FROM node:18-alpine AS base
WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .

USER node
EXPOSE 3000
ENV NODE_ENV=production
CMD ["node", "index.js"]
