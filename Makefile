
IMAGE_NAME ?= env_linux
TAG ?= 0.1.0
CONTAINER_NAME ?= env_linux
VOLUME ?= /home:/home

.PHONY: build run stop rm clean log shell

build:
	docker build --network host -t $(IMAGE_NAME):$(TAG) .

run: stop rm build
	docker run -it \
		--privileged \
		--network host \
		--name $(CONTAINER_NAME) \
		-v $(VOLUME) \
		$(IMAGE_NAME):$(TAG)

stop:
	docker stop $(CONTAINER_NAME) || true

rm:
	docker rm $(CONTAINER_NAME) || true

clean: stop rm
	docker rmi $(IMAGE_NAME):$(TAG) || true

logs:
	docker logs -f $(CONTAINER_NAME)

shell:
	docker exec -it $(CONTAINER_NAME) /bin/bash
