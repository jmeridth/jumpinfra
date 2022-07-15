ENV ?= test

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
	@while read line; do \
      tflint $$line --var-file="secrets.${ENV}.tfvars.json" \
				--var-file="envvars.${ENV}.tfvars.json"; \
    done < "tflint-enabled-directories";

.PHONY : keys
keys: ## Validate secret keys list matches keys in sensitive map
	@for app_name in api admin web; do \
		secret_keys="_secret_keys" && \
		app_secret_keys=$$app_name$$secret_keys && \
		secrets="_secrets" && \
		app_secrets=$$app_name$$secrets && \
		cat secrets.${ENV}.tfvars.json | jq '.$$app_secret_keys - .$$app_secrets | keys | length == 0'; \
	done

.PHONY : check
check: lint validate ## Run lint and validate

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

#.PHONY : api
#api: ## SSH onto ECS API instance
#	aws --profile jump${ENV} \
#	ecs execute-command \
#  --region us-west-2 \
#  --cluster jumpco-cluster-${ENV} \
#  --task $(shall aws --profile jump${ENV} ecs list-tasks) \
#  --container api-container-${ENV} \
#  --command "ls" \
#  -interactive
#
#.PHONY : admin
#admin: ## SSH onto ECS Admin instance
#	aws --profile jump${ENV} \
#	ecs execute-command \
#  --region us-west-2 \
#  --cluster jumpco-cluster-${ENV} \
#  --task $(shall aws --profile jump${ENV} ecs list-tasks) \
#  --container admin-container-${ENV} \
#  --command "ls" \
#  -interactive
#
#.PHONY : web
#web: ## SSH onto ECS Web instance
#	aws --profile jump${ENV} \
#	ecs execute-command \
#  --region us-west-2 \
#  --cluster jumpco-cluster-${ENV} \
#  --task $(shall aws --profile jump${ENV} ecs list-tasks) \
#  --container web-container-${ENV} \
#  --command "ls" \
#  -interactive
