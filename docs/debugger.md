# Debugger Service (Test Environment Only)

## TL;DR

```bash
cd terraform
make debugger

# on the container
env | grep $TYPEORM_PASSWORD # will show you the password
psql -h $TYPEORM_HOST -d $TYPEORM_DATABASE -p $TYPEORM_PORT -U $TYPEORM_USERNAME
# password prompt
```

### Details

In the `docker` folder is a `Dockerfile.debugger` and a `Makefile`.

Please update the packages installed in the `Dockerfile.debugger` if you want other tools.

```bash
cd docker
make ecr
```

This will build and push a new debugger image to test ECR for the debugger image

```bash
# from root of repo
cd terraform
make debugger

# on container
psql -h $TYPEORM_HOST -d $TYPEORM_DATABASE -p $TYPEORM_PORT -U $TYPEORM_USERNAME
```

This will allow you to run commands against the database
