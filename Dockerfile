FROM node:22.13-alpine3.21 as builder

WORKDIR /app
COPY package*.json ./
COPY tsconfig.json ./
COPY .npmrc ./
COPY src ./src
RUN npm install -g npm@latest
RUN npm ci && npm run build

FROM node:22.13-alpine3.21

WORKDIR /app
RUN apk add --no-cache curl
COPY package*.json ./
COPY tsconfig.json ./
COPY .npmrc ./
RUN npm install -g pm2 npm@latest
RUN npm ci --production
COPY --from=builder /app/build ./build

EXPOSE 4002

CMD [ "npm", "run", "start" ]
