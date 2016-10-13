FROM ruby:2.2.5-onbuild

RUN apt-get update && \
    apt-get install -y nodejs
