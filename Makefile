
IMAGE_NAME ?= ubun22
TAG ?= 1.0.2
CONTAINER_NAME ?= ubun22
WORKDIR ?= $(PWD)/..

.PHONY: build run stop rm clean log shell

build:
	docker build --network host -t $(IMAGE_NAME):$(TAG) .

run: stop rm build
	docker run -it \
		-w $(WORKDIR) \
		-u $(shell id -u):$(shell id -g) \
		--privileged \
		--network host \
		--name $(CONTAINER_NAME) \
		-v /home:/home \
		-v /etc/passwd:/etc/passwd:ro \
    	-v /etc/group:/etc/group:ro \
		-v /etc/shadow:/etc/shadow:ro \
		-v /etc/sudoers:/etc/sudoers:ro \
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
