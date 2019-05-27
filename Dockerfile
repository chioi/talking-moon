FROM ruby:2.6.3-alpine
ENV RACK_ENV development
EXPOSE 4567
WORKDIR /app

COPY Gemfile /app
COPY Gemfile.lock /app
COPY Rakefile /app
COPY config.ru /app
COPY lib /app/lib

RUN apk --update add --virtual build-dependencies ruby-dev build-base
RUN gem install --no-document bundler
RUN bundle install
RUN apk del build-dependencies

RUN adduser -D chat_server
RUN chown -R chat_server:nogroup /app
USER chat_server