CONTAINER=acgastropub

IMAGE_DEV=./Docker/docker-compose.dev.yml
ENV_DEV=./envs/.dev.env

IMAGE_PROD=./Docker/docker-compose.prod.yml
ENV_PROD=./envs/.prod.env

MANAGE_CMD=docker exec -it 

all:
	@echo "Hello $(LOGNAME), nothing to do by default"
	@echo "Try 'make help'"

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

define build_function
	docker stop $(CONTAINER) || true && docker rm $(CONTAINER) || true
	docker-compose -f $(1) --env-file $(2) --project-name $(CONTAINER) $(3)
endef

build_dev: ## Build the development container
	$(call build_function,$(IMAGE_DEV),$(ENV_DEV),build)

build_prod: ## Build the production container
	$(call build_function,$(IMAGE_PROD),$(ENV_PROD),build)

run_dev: ## Run the builded dev container
	$(call build_function,$(IMAGE_DEV),$(ENV_DEV),start)

run_prod: ## Run the builded prod container
	$(call build_function,$(IMAGE_PROD),$(ENV_PROD),start)

up_dev: ## Make the dev server up
	$(call build_function,$(IMAGE_DEV),$(ENV_DEV),up)

up_prod: ## Make the dev server up
	$(call build_function,$(IMAGE_PROD),$(ENV_PROD),up)

restart: ## Restart the container
	docker restart $(CONTAINER)

down: ## Stop the container
	docker stop $(CONTAINER)

remove:
	docker stop $(CONTAINER) || true && docker rm $(CONTAINER)
	


	

