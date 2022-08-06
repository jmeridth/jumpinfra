# SSH onto ECS service instances

## TL;DR

[Setup aws cli](setup-aws-cli.md)

```bash
cd terraform
make api
```

## Makefile target

```bash
cd terraform
make api
```

Replace `api` with `admin` or `web` to get onto those instances

Provide `ENV` argument for non-test environments

```bash
cd terraform
make admin ENV=staging
```

*NOTE:* We may have more than one instance running.  Currently this command targets the first in the list returns from the `aws ecs list-tasks` command.

## If Make target fails

### Setup/Requirements

[Setup AWS CLI and Credentials](setup-aws-cli.md)

#### Get ECS service task id

Login to the AWS console (web UI) and go to ECS and click on the cluste and then the [Tasks tab](https://us-west-2.console.aws.amazon.com/ecs/home?region=us-west-2#/clusters/jumpco-cluster-test/tasks).

Get the ID of desired task (api, admin or web) from the first column

#### Connect to ECS Service via AWS CLI

```bash
aws --profile jumptest \
  ecs execute-command \
  --region us-west-2 \
  --cluster jumpco-cluster-test \
  --task $(shell aws --profile jumptest ecs list-tasks --cluster jumpco-cluster-test --service-name api-test | jq '.taskArns[0] | split("/") | .[-1]') \
  --container admin-container-test \
  --command "/bin/bash" \
  --interactive
```
