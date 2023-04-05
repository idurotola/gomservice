# Makefile for deploying microservices on Kubernetes

# Set the Kubernetes namespace
NAMESPACE=default

# Set the image tag for all services
IMAGE_TAG=latest

# Set the paths to the service deployment and service files
USERS_DEPLOYMENT=./user_service/deployment.yaml
USERS_SERVICE=./user_service/service.yaml
ORDERS_DEPLOYMENT=./order_service/deployment.yaml
ORDERS_SERVICE=./order_service/service.yaml
PAYMENTS_DEPLOYMENT=./payment_service/deployment.yaml
PAYMENTS_SERVICE=./payment_service/service.yaml
NGINX_DEPLOYMENT=./nginxlocal/deployment.yaml
NGINX_SERVICE=./nginxlocal/service.yaml
INGRESS_RESOURCE=./ingress/services_ingress.yaml
CONFIG_MAP=./ingress/configmap.yaml

deploy: users orders payments nginx ingress

users:
	kubectl apply -n $(NAMESPACE) -f $(USERS_DEPLOYMENT)
	kubectl apply -n $(NAMESPACE) -f $(USERS_SERVICE)

orders:
	kubectl apply -n $(NAMESPACE) -f $(ORDERS_DEPLOYMENT)
	kubectl apply -n $(NAMESPACE) -f $(ORDERS_SERVICE)

payments:
	kubectl apply -n $(NAMESPACE) -f $(PAYMENTS_DEPLOYMENT)
	kubectl apply -n $(NAMESPACE) -f $(PAYMENTS_SERVICE)

nginx:
	kubectl apply -n $(NAMESPACE) -f $(NGINX_DEPLOYMENT)
	kubectl apply -n $(NAMESPACE) -f $(NGINX_SERVICE)

ingress:
	kubectl apply -n $(NAMESPACE) -f $(INGRESS_RESOURCE)

config:
	kubectl apply -n $(NAMESPACE) -f $(CONFIG_MAP)

clean:
	kubectl delete -n $(NAMESPACE) -f $(USERS_DEPLOYMENT) || true
	kubectl delete -n $(NAMESPACE) -f $(USERS_SERVICE) || true
	kubectl delete -n $(NAMESPACE) -f $(ORDERS_DEPLOYMENT) || true
	kubectl delete -n $(NAMESPACE) -f $(ORDERS_SERVICE) || true
	kubectl delete -n $(NAMESPACE) -f $(PAYMENTS_DEPLOYMENT) || true
	kubectl delete -n $(NAMESPACE) -f $(PAYMENTS_SERVICE) || true
	kubectl delete -n $(NAMESPACE) -f $(NGINX_DEPLOYMENT) || true
	kubectl delete -n $(NAMESPACE) -f $(NGINX_SERVICE) || true
	kubectl delete -n $(NAMESPACE) -f $(INGRESS_RESOURCE) || true


# Makefile for looping over a list of directories

# List of directories to loop over
DIRS := \
	user_service \
	order_service \
  payment_service \
  nginxlocal

deploy_all:
	$(foreach dir,$(DIRS), \
		echo "Deploying service in directory $(dir)..." && \
		kubectl apply -n $(NAMESPACE) -f ./$(dir)/deployment.yaml && \
		kubectl apply -n $(NAMESPACE) -f ./$(dir)/service.yaml && \
		echo "Done deploying in $(dir)"; \
	)

build:
	$(foreach dir,$(DIRS), \
		echo "Building image in directory $(dir)..." && \
		cd ./$(dir) && \
    [ -f go.mod ] && go mod tidy; \
 		[ -f Dockerfile ] && docker build -t myregistry.$(dir):v1 . || true &&  \
		echo "Done building"&& \
		cd ..; \
	)
