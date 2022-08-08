# Environment Variables

## TL;DR

They are located at `terraform/envvars.[ENV].tfvars.json`

### Environment variables

Environment variables are located in `terraform/envvars.[ENV].tfvars.json` files. These are source controlled.

If an environment variable is missing, please check `terraform/locals.tf` as some of them are dynamic based on terraform resource names (i.e. database name, s3 bucket name and url, etc).  This does not mean you can edit those items in `terraform/locals.tf`
