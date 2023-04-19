FROM builder:latest

WORKDIR /node/
RUN npm run test
