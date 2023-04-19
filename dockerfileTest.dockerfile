FROM builder:latest

WORKDIR /node.js/
RUN npm run test
