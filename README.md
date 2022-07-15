# JUMP INFRA

## Pre-reqs

Have the following in your `~/.aws/credentials` file.
(you can run `aws configure` locally and it will prompt you)

```ini
[jumpstaging]
region=us-west-2
aws_access_key_id = FILL_ME_IN
aws_secret_access_key = FILL_ME_IN
[jumptest]
region=us-west-2
aws_access_key_id = FILL_ME_IN
aws_secret_access_key = FILL_ME_IN
```

when you run the make targets below they will automatically
export the environment profile into `AWS_PROFILE` environment
variable

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
```

OR

```bash
make check # runs both lint and validate
```

### Environment variables

Environment variables are located in `terraform/envvars.[ENV].tfvars.json` files. These are source controlled.

If an environment variable is missing, please check `terraform/locals.tf` as some of them are dynamic based on terraform resource names.  This does not mean you can edit those items in `terraform/locals.tf`.

### Secrets

Secrets are located in `terraform/secrets.[ENV].tfvars.json` and these are NOT source controlled.  There is an example file located at `terraform/secrets.example.tfvars.json` that IS source controlled.  This file should be updated if any new secrets are added to environment specific tfvars files.

#### Get secrets into GitHub secrets for CI/CD (GitHub Actions)

```bash
cd terraform
make b64e_secrets
```

This will base 64 encode the `terraform/secrets.[ENV].tfvars.json` file into your local clipboard (OSX only currently).

Then you can overwrite or recreate the [ENV]_SECRETS GitHub secret on this repository.  This is what the GitHub actions use to pass secrets to terraform.

Why do we need to base64 encode the value before storing?

Great question.  It is because GitHub does not allow json to be stored in secrets by default.  By base64 encoding we get around this.
