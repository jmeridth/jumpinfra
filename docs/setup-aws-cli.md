# Setup AWS CLI

## TL;DR

- `brew install awscli`
- `aws configure --profile jumpstaging`

You'll end up with something like this in `~/.aws/credentials` file.

```ini
[jumpstaging]
region=us-west-2
aws_access_key_id = REDACTED
aws_secret_access_key = REDACTED
```

For other environments you do `aws configure --profile jump[ENVNAME]`

## Install

[AWS Docs](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)

If you have [homebrew](https://brew.sh/) installed you can run the following:

`brew install awscli`

This will install the v2 aws cli

## Configure

run `aws configure --profile jumpstaging`

[Docs on this](https://docs.aws.amazon.com/cli/latest/userguide/cli-configure-quickstart.html)

This will create `~/.aws/credentials` and `~/.aws/config` files on your local laptop
