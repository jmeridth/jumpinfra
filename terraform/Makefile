ENV ?= staging
LOG_LEVEL ?= error

define ecs_ssh
	aws --profile jump${ENV} \
		ecs execute-command \
		--region us-west-2 \
		--cluster jumpco-cluster-${ENV} \
		--task $(shell aws --profile jump${ENV} ecs list-tasks --cluster jumpco-cluster-${ENV} --service-name $(1)-${ENV} | jq '.taskArns[0] | split("/") | .[-1]') \
		--container $(1)-container-${ENV} \
		--command "/bin/bash" \
		--interactive
endef

define keys_diff
	yq '(.$(1)_secrets | keys)-.$(1)_secrets_keys' env/${ENV}/$(1).secrets.${ENV}.yaml
endef

define b64e_secrets
	cat ./env/${ENV}/$(1).secrets.${ENV}.yaml | base64 | pbcopy
endef

.PHONY : help
help: # Display help
	@echo "Usage: make [target] [ENV=staging]"
	@echo "Default ENV is staging"
	@echo "targets:"
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

.PHONY : env
env: ## Echo out environment
	@echo $(ENV)

.PHONY : clearcache
clearcache: ## Clear Terragrunt cache
	@find . -type d -name ".terragrunt-cache" -exec rm -rf {} ";"

.PHONY : validate
validate: ## Terragrunt validate
	cd env/${ENV} && \
	export AWS_PROFILE=jump${ENV} && \
	export TERRAGRUNT_LOG_LEVEL=${LOG_LEVEL} && \
	terragrunt run-all validate

.PHONY : api_keys
api_keys: ## Validate secret api keys list matches api keys in sensitive map
	@if [ $(shell $(call keys_diff,api) | yq length) -gt 0 ]; then \
		echo "ERROR: api_secrets_keys does not match api_secrets keys" && \
		$(call keys_diff,api) && \
		exit 1; \
	fi

.PHONY : web_keys
web_keys: ## Validate secret web keys list matches web keys in sensitive map
	@if [ $(shell $(call keys_diff,web) | yq length) -gt 0 ]; then \
		echo "ERROR: web_secrets_keys does not match web_secrets keys" && \
		$(call keys_diff,web) && \
		exit 1; \
	fi

.PHONY : secrets
secrets: ## Generate secrets from templates
	$(eval API_FILE := env/$(ENV)/api.secrets.$(ENV).yaml)
	$(eval WEB_FILE := env/$(ENV)/web.secrets.$(ENV).yaml)
	@if [ ! -f "$(API_FILE)" ]; then cp api.secrets.template.yaml $(API_FILE); fi
	@if [ ! -f "$(WEB_FILE)" ]; then cp web.secrets.template.yaml $(WEB_FILE); fi

.PHONY : keys
keys: api_keys web_keys ## Run key checks

.PHONY : check
check: validate keys ## Run some checks

.PHONY : show
show: ## Show Terragrunt
	terragrunt show -json | jq .

.PHONY : b64e_api_secrets
b64e_api_secrets: ## Base64 encode API secrets to be stored in GitHub secrets for CI
	$(call b64e_secrets,api)

.PHONY : b64e_web_secrets
b64e_web_secrets: ## Base64 encode WEB secrets to be stored in GitHub secrets for CI
	$(call b64e_secrets,web)

.PHONY : console
console: ## Terragrunt console
	terragrunt console

.PHONY : init
init: ## Run Terragrunt Init
	cd env/${ENV} && \
	export AWS_PROFILE=jump${ENV} && \
	terragrunt init

.PHONY : plan
plan: ## Run Terragrunt Plan
	cd env/${ENV} && \
	export AWS_PROFILE=jump${ENV} && \
	export TERRAGRUNT_LOG_LEVEL=${LOG_LEVEL} && \
	terragrunt run-all plan

.PHONY : apply
apply: ## Run Terragrunt Apply
	cd env/${ENV} && \
	export AWS_PROFILE=jump${ENV} && \
	export TERRAGRUNT_LOG_LEVEL=${LOG_LEVEL} && \
	terragrunt run-all apply

.PHONY : api
api: ## SSH onto ECS API instance
	$(call ecs_ssh,api)

.PHONY : web
web: ## SSH onto ECS Web instance
	$(call ecs_ssh,web)

.PHONY : debugger
debugger: ## SSH onto ECS Debugger instance
	$(call ecs_ssh,debugger)
