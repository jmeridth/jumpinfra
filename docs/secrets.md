# Secrets

Secrets should *NEVER* be committed to this repository.

## TL;DR

They are located inside the environment folders located at `terraform/env/`

Example for `test` environment:

    terragorm/env/test/api.secrets.test.yaml`
    terragorm/env/test/web.secrets.test.yaml`

Example for `staging` environment:

    terragorm/env/staging/api.secrets.staging.yaml`
    terragorm/env/staging/web.secrets.staging.yaml`

They are stored in Github repo secrets as base64 to avoid Github saying we're storing JSON in a secret.  There is a Makefile target to help you.

## Location

Secrets are located in `[APP].secrets.[ENV].yaml` and these are NOT source controlled.  There is an example file located at `terraform/[APP].secrets.template.yaml` that IS source controlled.  This file should be updated if any new secrets are added to environment specific tfvars files.

## Get secrets into GitHub secrets for CI/CD (GitHub Actions)

```bash
cd terraform
make b64e_secrets
```

This will base 64 encode the `terraform/env/[ENV]/[APP].secrets.[ENV].yaml` file into your local clipboard (OSX only currently).

Then you can overwrite or recreate the [APP]_[ENV]_SECRETS GitHub secret on this repository.  This is what the GitHub actions use to pass secrets to terraform.

Why do we need to base64 encode the value before storing?

Great question.  It is because GitHub does not allow json to be stored in secrets by default.  By base64 encoding we get around this.
