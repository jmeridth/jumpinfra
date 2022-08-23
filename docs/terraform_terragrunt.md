# Terraform/Terragrunt

## TL;DR

```bash
aws configure --profile jumptest
cd terraform
make init
make plan
make apply
```

## Other environments

ENV argument defaults to `staging` if not provided. Example running on non-test environment.

```bash
cd terraform
make init ENV=otherenv
make plan ENV=otherenv
make apply ENV=otherenv
```

### Other commands

```bash
make validate
make keys
```

OR

```bash
make check # runs all of the above in one command
```
