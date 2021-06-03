FROM node:14.17

WORKDIR /opt/dockerized-cra
ARG UID=1001
RUN adduser -u $UID --disabled-password --gecos "" dockerized-cra-user

RUN chown -R dockerized-cra-user /opt/dockerized-cra

USER dockerized-cra-user
COPY package.json yarn.lock /opt/dockerized-cra/
RUN yarn install && yarn cache clean --all
ENV PATH /opt/dockerized-cra/node_modules/.bin:$PATH

WORKDIR /opt/dockerized-cra/app
COPY . /opt/dockerized-cra/app






