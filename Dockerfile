FROM ruby:2.2.5-onbuild

COPY ./ /usr/src/app
WORKDIR /usr/src/app

RUN apt-get update && \
    apt-get install -y build-essential nodejs mysql-client
