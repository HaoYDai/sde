
IMAGE_NAME ?= ubun18
TAG ?= 1.0.3
CONTAINER_NAME ?= $(IMAGE_NAME)
WORKDIR ?= $(PWD)/..
RESOURCE_DIR ?= $(shell pwd)/resource

.PHONY: build run stop rm clean log shell

install_resources:
	@echo "Installing resources..."
	export https_proxy=http://127.0.0.1:7897 http_proxy=http://127.0.0.1:7897 all_proxy=socks5://127.0.0.1:7897
	bash $(RESOURCE_DIR)/download_resource.sh
	@echo "Resources installed."

build: install_resources
	docker build \
		--build-arg HOST_USER=$(shell whoami) \
		--network host \
		-t $(IMAGE_NAME):$(TAG) .

run: stop rm build
	docker run -it \
		-w $(WORKDIR) \
		--privileged \
		--network host \
		--name $(CONTAINER_NAME) \
		-v /home/$(shell whoami):/home/$(shell whoami) \
		$(IMAGE_NAME):$(TAG) /bin/bash

stop:
	docker stop $(CONTAINER_NAME) || true

push: build
	docker tag $(IMAGE_NAME):$(TAG) g-rdhp3682-docker.pkg.coding.net/builds/docker/$(IMAGE_NAME):$(TAG)
	docker push g-rdhp3682-docker.pkg.coding.net/builds/docker/$(IMAGE_NAME):$(TAG)

rm:
	docker rm $(CONTAINER_NAME) || true

clean: stop rm
	docker rmi $(IMAGE_NAME):$(TAG) || true

logs:
	docker logs -f $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
