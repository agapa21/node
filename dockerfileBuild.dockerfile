FROM node:latest

RUN git clone https://github.com/agapa21/node
WORKDIR node
RUN npm install
RUN npm run build
