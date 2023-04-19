FROM node:latest

RUN git clone https://github.com/agapa21/node.js
WORKDIR node.js
RUN npm install
RUN npm run build
