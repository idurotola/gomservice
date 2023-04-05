### gomservice

_A simple micro-service barebones using K8s, Docker, go, nginx and a makefile for the ochestration. It also uses ingress controller for networking_

**client ----> nginx ----> services (user, order, payment)**
#### To add a new service 
  1. Create service directory 
  2. Create service app file in the directory
  3. Create both the deployment.yaml and service.yaml for app deployment and service definitions
  4. Add the new service and its endpoint to both the service-ingress.yaml file and the configmap.yaml

#### To run
  1. Make sure you have docker and kubernetes running 
  2. run make build && make deploy_all
  3. run make ingress && make config 

**TODO:**
  >1. add a database service as a stateful service
  >2. wire up authentication as part of user service