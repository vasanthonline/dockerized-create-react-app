FROM node:14.17

WORKDIR /opt/dockerized-cra
ARG UID=1001
RUN adduser -u $UID --disabled-password --gecos "" dockerized-cra-user

RUN chown -R dockerized-cra-user /opt/dockerized-cra

USER dockerized-cra-user
WORKDIR /opt/dockerized-cra
COPY . /opt/dockerized-cra