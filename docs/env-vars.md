# Environment Variables

## TL;DR

They are located inside the environment folders located at `terraform/env/`

Example for `test` environment:

    terragorm/env/test/api.envvars.test.yaml`
    terragorm/env/test/web.envvars.test.yaml`

Example for `staging` environment:

    terragorm/env/staging/api.envvars.staging.yaml`
    terragorm/env/staging/web.envvars.staging.yaml`

### Environment variables

Environment variables are located in `[APP].envvars.[ENV].yaml` files. These are source controlled.

If an environment variable is missing, please check the `inputs` section of a `terragrunt.hcl` file as some of them are dynamic based on terraform resource names (i.e. database name, s3 bucket name and url, etc).
