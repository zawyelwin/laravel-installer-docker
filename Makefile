.ONESHELL:
.SHELL := /usr/bin/bash

IMAGE_NAME ?= zylwin/laravel-installer
DOCKERFILE ?= Dockerfile
CONTEXT ?= .
INSTALLER_VERSION ?= "5.28.0"
PLATFORMS ?= linux/amd64,linux/arm64
BUILDER ?= laravel-installer-builder


help: ## Shows the help for a subcommand
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

prep:
	@docker info > /dev/null || (echo "$(RED)Docker daemon is not running, please start docker"; exit 1)

build: prep ## Build a local single-arch image for testing
	docker build --build-arg INSTALLER_VERSION=$(INSTALLER_VERSION) -t $(IMAGE_NAME):$(INSTALLER_VERSION) -t $(IMAGE_NAME):latest -f $(DOCKERFILE) $(CONTEXT)

builder: prep ## Create and select the buildx builder for multi-arch builds
	@docker buildx inspect $(BUILDER) > /dev/null 2>&1 || docker buildx create --name $(BUILDER) --driver docker-container
	@docker buildx use $(BUILDER)

push: builder ## Build and push multi-arch images (amd64 + arm64) to docker hub
	docker buildx build --platform $(PLATFORMS) --build-arg INSTALLER_VERSION=$(INSTALLER_VERSION) \
		-t $(IMAGE_NAME):$(INSTALLER_VERSION) -t $(IMAGE_NAME):latest \
		-f $(DOCKERFILE) --push $(CONTEXT)


.PHONY: build builder push
