# JUMP INFRA

## Pre-reqs

Have the following in your `~/.aws/credentials` file.
(you can run `aws configure` locally and it will prompt you)

  [jumpstaging]
  region=us-west-2
  aws_access_key_id = FILL_ME_IN
  aws_secret_access_key = FILL_ME_IN
  [jumptest]
  region=us-west-2
  aws_access_key_id = FILL_ME_IN
  aws_secret_access_key = FILL_ME_IN

when you run the make targets below they will automatically
export the environment profile into `AWS_PROFILE` environment
variable

## Other environments

ENV defaults to `test` if not provided

  cd terraform
  make init ENV=staging
  make plan ENV=staging
  make apply ENV=staging

### Other commands

  make validate
  make lint
