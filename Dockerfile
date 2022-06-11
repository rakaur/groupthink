# syntax=docker/dockerfile:1
FROM ruby:3.1.0-alpine AS build
RUN apk update && \
    apk upgrade && \
    apk add build-base tzdata postgresql-dev
WORKDIR /app
COPY Gemfile* .
RUN bundle install --jobs=4

FROM ruby:3.1.0-alpine
RUN apk update && \
    apk upgrade && \
    apk add bash tzdata postgresql-client yarn && \
    rm -rf /var/cache/apk/*
WORKDIR /app
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY . .

EXPOSE 3000
ENTRYPOINT ./docker-entrypoint.sh puma -C config/puma.rb
