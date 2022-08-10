ENV ?= test

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

.PHONY : help
help: # Display help
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

.PHONY : env
env: ## Echo out environment
	@echo $(ENV)

.PHONY : validate
validate: ## Terraform validate
	@terraform validate

.PHONY : lint
lint: ## Run tflint
	@tflint --init && \
	while read line; do \
      tflint $$line --var-file="secrets.${ENV}.tfvars.json" \
				--var-file="envvars.${ENV}.tfvars.json"; \
    done < "tflint-enabled-directories";

.PHONY : keys
keys: ## Validate secret keys list matches keys in sensitive map
	@python3 ../scripts/check_secrets.py ${ENV}

.PHONY : check
check: lint validate keys ## Run some checks

.PHONY : show
show: ## Show Terraform
	terraform show -json | jq .

.PHONY : b64e_secrets
b64e_secrets: ## Base64 encode secrets to be stored in GitHub secrets for CI
	cat secrets.${ENV}.tfvars.json | base64 | pbcopy

.PHONY : console
console: ## Terraform console
	terraform console -var-file="secrets.${ENV}.tfvars.json" \
		-var-file="envvars.${ENV}.tfvars.json"

.PHONY : init
init: ## Initialize Terraform
	export AWS_PROFILE=jump${ENV} && \
	terraform init -var-file="secrets.${ENV}.tfvars.json" \
		-var-file="envvars.${ENV}.tfvars.json" \
		-backend-config=$(ENV).tfbackend

.PHONY : plan
plan: ## Run Terraform Plan
	export AWS_PROFILE=jump${ENV} && \
	terraform plan -var-file="secrets.${ENV}.tfvars.json" \
		-var-file="envvars.${ENV}.tfvars.json"

.PHONY : apply
apply: ## Run Terraform Apply
	export AWS_PROFILE=jump${ENV} && \
	terraform apply -auto-approve -var-file="secrets.${ENV}.tfvars.json" \
		-var-file="envvars.${ENV}.tfvars.json"

.PHONY : api
api: ## SSH onto ECS API instance
	$(call ecs_ssh,api)

.PHONY : admin
admin: ## SSH onto ECS Admin instance
	$(call ecs_ssh,admin)

.PHONY : web
web: ## SSH onto ECS Web instance
	$(call ecs_ssh,web)

.PHONY : debugger
debugger: ## SSH onto ECS Debugger instance
	$(call ecs_ssh,debugger)
