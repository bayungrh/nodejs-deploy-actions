FROM node:10-alpine

RUN mkdir -p /usr/src/app

WORKDIR /usr/src/app

ENV PATH /usr/src/app/node_modules/.bin:$PATH

COPY package.json /usr/src/app/package.json

RUN npm install

COPY . /usr/src/app

EXPOSE 3000

CMD [ "npm", "run", "start"]
