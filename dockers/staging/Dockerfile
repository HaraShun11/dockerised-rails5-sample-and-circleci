FROM ruby:2.4.0
ENV LANG C.UTF-8
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs lsof

ENV ENTRYKIT_VERSION 0.4.0
ARG AWS_KMS_KEY_ID
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY

WORKDIR /

RUN apt-get install openssl \
  && wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
  && mv entrykit /bin/entrykit \
  && chmod +x /bin/entrykit \
  && entrykit --symlink

RUN gem install bundler
RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config build.mysql2 --use-system-libraries && \
    bundle install --jobs 20 --retry 5

ADD . /app

EXPOSE 3000

RUN bundle exec yaml_vault decrypt config/encrypted_secrets.yml -o config/secrets.yml \
      -k $.production,$.staging \
      --cryptor=aws-kms \
      --aws-region=ap-northeast-1 \
      --aws-kms-key-id=${AWS_KMS_KEY_ID} \
      --aws-access-key-id=${AWS_ACCESS_KEY_ID} \
      --aws-secret-access-key=${AWS_SECRET_ACCESS_KEY}

RUN RAILS_ENV=staging bundle exec rake env:setup['.env']

ENTRYPOINT [ \
  "codep", \
    "/bin/sh /app/dockers/staging/setup.sh", \
    "bundle exec rails s puma -b 0.0.0.0 -p 3000 -e staging" \
]
