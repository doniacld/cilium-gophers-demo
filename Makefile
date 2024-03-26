IMAGE_NAME := gopher-service
IMAGE_TAG := latest

.PHONY: build-image
build-image:
	docker build -t $(IMAGE_NAME):$(IMAGE_TAG) .

.PHONY: deploy
deploy: build-image
	kind load docker-image $(IMAGE_NAME):$(IMAGE_TAG) -n kind
	kubectl apply -f eu-gopher-deployment.yaml
	kubectl apply -f us-gopher-deployment.yaml
	kubectl expose deployment/gopher-colony-eu
	kubectl expose deployment/gopher-colony-us

.PHONY: deploy-au
deploy-au:
	kubectl apply -f au-gopher-deployment.yaml
	kubectl expose deployment/gopher-colony-au

.PHONY: test-eu
test-eu: test-eu-eu test-eu-us

.PHONY: test-eu-eu
test-eu-eu:
	@echo "Testing gopher traveling within the same continent (EU)"
	kubectl exec -it $$(kubectl get pods -l app=gopher,continent=eu -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "curl -vsS gopher-colony-eu:8080 && echo"

.PHONY: test-eu-us
test-eu-us:
	@echo "\nTesting gopher traveling to a different continent (EU to US)"
	kubectl exec -it $$(kubectl get pods -l app=gopher,continent=eu -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "curl -vsS gopher-colony-us:8080 && echo"

.PHONY: test-eu-au
test-eu-au:
	@echo "Testing gopher traveling within the same continent (EU)"
	kubectl exec -it $$(kubectl get pods -l app=gopher,continent=eu -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "curl -vsS gopher-colony-au:8080 && echo"

.PHONY: test-us
test-eu: test-us-us test-us-eu

.PHONY: test-us-us
test-us-us:
	@echo "Testing gopher traveling within the same continent (US)"
	kubectl exec -it $$(kubectl get pods -l app=gopher,continent=us -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "curl -vsS gopher-colony-us:8080 && echo"

.PHONY: test-us-eu
test-us-eu:
	@echo "\nTesting gopher traveling to a different continent (US to EU)"
	kubectl exec -it $$(kubectl get pods -l app=gopher,continent=us -o jsonpath='{.items[0].metadata.name}') -- /bin/sh -c "curl -vsS gopher-colony-eu:8080 && echo"

.PHONY: clean
clean:
	kubectl delete -f eu-gopher-deployment.yaml
	kubectl delete -f us-gopher-deployment.yaml
	kubectl delete svc gopher-colony-eu gopher-colony-us

.PHONY: all
all: deploy test

# TODO DONIA Update the help
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  build-image  Build the Docker image for the gopher service"
	@echo "  deploy       Deploy gopher colonies and apply network policy"
	@echo "  test         Test gopher traveling"
	@echo "  clean        Delete deployed resources"
	@echo "  all          Deploy, test, and clean up"