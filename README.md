# JUMP INFRA

## TL;DR

*NOTE:* Ideally you will not run terraform commands locally anymore.  This is now done through Github pull requests and slash commands on this repository

If you need to run stuff locally though:

```bash
aws configure --profile jumptest
cd terraform
make init
make plan
make apply
```

```bash
cd terraform
make help
```

## Docs

[Docs](docs/)
