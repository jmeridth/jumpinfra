# Terraform

## TL;DR

```bash
aws configure --profile jumptest
cd terraform
make init
make plan
make apply
```

## Other environments

ENV argument defaults to `test` if not provided. Example running on staging environment.

```bash
cd terraform
make init ENV=staging
make plan ENV=staging
make apply ENV=staging
```

### Other commands

```bash
make validate
make lint
make keys
```

OR

```bash
make check # runs all of the above in one command
```
