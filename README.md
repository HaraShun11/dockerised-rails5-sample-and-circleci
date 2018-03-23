# dockerised-rails5-sample-and-circleci

# Dependency
- Docker
- [CircleCI 2.0](https://circleci.com/docs/2.0/local-jobs/)
- AWS - ECS

# Setup
```
  $ docker-compose build
  $ docker-compose run --rm api rake db:create (or db:migrate)
  $ docker-compose up
```

# Usage
## setup all server
```
  $ docker-compose build
  $ docker-compose up
```

## test
```
  $ docker-compose run --rm -e "RAILS_ENV=test" api bundle exec rspec
```

## lint
```
  $ docker-compose run --rm api bundle exec guard --force-polling
```

# Automatic Pushing with circleci
```
  $ cat .circleci/config.yml
```

# Use dotenv and yaml_vault

### development and test(not circleci)
write .env file directly

### staging and production
use yaml_vault to encrypt and decrypt
```
  # encrypt only production and decrypt
  $ bundle exec yaml_vault encrypt config/secrets.yml -o config/encrypted_secrets.yml -k $.production,$.staging --cryptor=aws-kms --aws-region=ap-northeast-1 --aws-kms-key-id=<AWS_KMS_KEY_ID> --aws-access-key-id=<AWS_ACCESS_KEY_ID> --aws-secret-access-key=<AWS_SECRET_ACCESS_KEY>

  # decrypt
  $ bundle exec yaml_vault decrypt config/encrypted_secrets.yml -o config/secrets.yml -k $.production,$.staging --cryptor=aws-kms --aws-region=ap-northeast-1 --aws-kms-key-id=<AWS_KMS_KEY_ID> --aws-access-key-id=<AWS_ACCESS_KEY_ID> --aws-secret-access-key=<AWS_SECRET_ACCESS_KEY>
```
