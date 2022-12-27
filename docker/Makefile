# ONLY FOR STAGING ENVIRONMENT
# HENCE staging IS HARDCODED INSTEAD OF USER ${ENV}

ACCOUNT_ID = $(shell aws --profile jumpstaging sts get-caller-identity --query "Account" --output text)

.PHONY : help
help: # Display help
	@awk -F ':|##' \
		'/^[^\t].+?:.*?##/ {\
			printf "\033[36m%-30s\033[0m %s\n", $$1, $$NF \
		}' $(MAKEFILE_LIST)

.PHONY : build
build: ## Build docker image locally
	docker build --platform=linux/amd64 -f Dockerfile.debugger -t debugger-staging .

.PHONY : ecr
ecr: ## Build new container image and push to ECR
	export AWS_PROFILE=jumpstaging
	docker build --platform=linux/amd64 -f Dockerfile.debugger -t debugger-staging .
	docker tag debugger-staging:latest ${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/debugger-staging:latest
	aws ecr get-login-password --profile jumpstaging --region us-west-2 | docker login --username AWS --password-stdin ${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com
	docker push ${ACCOUNT_ID}.dkr.ecr.us-west-2.amazonaws.com/debugger-staging:latest

.PHONY : deploy
deploy: ecr ## Build new container image, push to ECR and deploy to ECS
	export AWS_PROFILE=jumpstaging
	aws ecs update-service --cluster jumpco-cluster-staging --service debugger-staging --force-new-deployment
