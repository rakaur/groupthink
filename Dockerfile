# syntax=docker/dockerfile:1
FROM ruby:3.1.0-alpine AS build
RUN apk update && \
    apk upgrade && \
    apk add build-base tzdata postgresql-dev
WORKDIR /streams
COPY Gemfile* .
RUN bundle install --jobs=4

FROM ruby:3.1.0-alpine
RUN apk update && \
    apk upgrade && \
    apk add tzdata postgresql-client yarn && \
    rm -rf /var/cache/apk/*
WORKDIR /streams
RUN gem install foreman
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . .

EXPOSE 3000
ENTRYPOINT ./docker-entrypoint.sh foreman start
