FROM node:14-buster

WORKDIR /app

COPY package*.json ./
RUN npm install && \
    npm install -g webpack && \
    npm install --save-dev webpack

COPY . .

EXPOSE 3000
CMD ["npm", "start"]
