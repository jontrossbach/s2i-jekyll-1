
IMAGE_NAME = s2i-jekyll
EXAMPLE_NAME = jekyll

build:
	#docker build -t $(IMAGE_NAME) .
	oc start-build -F ${IMAGE_NAME}
	sleep 5
	oc logs -f bc/${EXAMPLE_NAME}

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
