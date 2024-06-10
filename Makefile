.ONESHELL:
.SHELL := /usr/bin/bash

IMAGE_NAME ?= zylwin/laravel-installer
DOCKERFILE ?= Dockerfile
CONTEXT ?= .
INSTALLER_VERSION ?= "5.8.2"


help: ## Shows the help for a subcommand
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prep:
	@docker info > /dev/null || (echo "$(RED)Docker daemon is not running, please start docker"; exit 1)

build: ## Build container images for laravel installer with given tags
	docker build --build-arg INSTALLER_VERSION=$(INSTALLER_VERSION) -t $(IMAGE_NAME):$(INSTALLER_VERSION) -f $(DOCKERFILE) $(CONTEXT)
	docker build --build-arg INSTALLER_VERSION=$(INSTALLER_VERSION) -t $(IMAGE_NAME):latest -f $(DOCKERFILE) $(CONTEXT)

push: ## Pusg container images to docker hub
	docker push $(IMAGE_NAME):$(INSTALLER_VERSION)
	docker push $(IMAGE_NAME):latest


.PHONY: build push
