FROM ruby:2.4.0
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN gem install bundler
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config build.mysql2 --use-system-libraries && \
    bundle install --jobs 20 --retry 5

ENV APP_HOME /makeup-server
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME
