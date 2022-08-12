MINIKUBE_CONFIG_CPUS	= 2
MINIKUBE_CONFIG_RAM		= 4096

MINIKUBE_PROFILE 		= -p sandbox
MINIKUBE_WORKER_NODES 	= --nodes 3
MINIKUBE_ADDONS			= ingress

update-minikube-config:
	minikube config set cpus $(MINIKUBE_CONFIG_CPUS)
	minikube config set memory $(MINIKUBE_CONFIG_RAM)

create-k8s-cluster:
	minikube start $(MINIKUBE_WORKER_NODES) $(MINIKUBE_PROFILE)
	$(foreach addon, $(MINIKUBE_ADDONS), minikube addons enable $(addon) $(MINIKUBE_PROFILE))

update-k8s-cluster:
	kubectl apply -f k8s/service/*

delete-k8s-cluster:
	minikube delete $(MINIKUBE_PROFILE)

clean:
	minikube delete $(MINIKUBE_PROFILE)