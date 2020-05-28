IMAGE := lambdalisue/docker-update-cloudflare-dns
TAG   := latest

# http://postd.cc/auto-documented-makefile/
.DEFAULT_GOAL := help
.PHONY: help
help: ## Show this help
	@grep -E '^[0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "%-30s %s\n", $$1, $$2}'

.PHONY: image
image: ## Build a docker image
	@docker build \
	    -t ${IMAGE}:${TAG} \
	    .

.PHONY: run
run: ## Build a docker image
	@docker run --rm -it \
	    -e ZONE=${ZONE} \
	    -e DNSRECORD=${DNSRECORD} \
	    -e AUTH_EMAIL=${AUTH_EMAIL} \
	    -e AUTH_KEY=${AUTH_KEY} \
	    ${IMAGE}:${TAG}

.PHONY: pull
pull: ## Pull a docker image
	@docker pull ${IMAGE}:${TAG}

.PHONY: push
push: ## Push a docker image
	@docker push ${IMAGE}:${TAG}
