MINIKUBE_CONFIG_CPUS	= 2
MINIKUBE_CONFIG_RAM		= 4096

MINIKUBE_PROFILE 		= -p sandbox
MINIKUBE_WORKER_NODES 	= --nodes 3
MINIKUBE_ADDONS			= ingress

update-minikube-config:
	minikube config set driver docker

	minikube config set cpus $(MINIKUBE_CONFIG_CPUS)
	minikube config set memory $(MINIKUBE_CONFIG_RAM)

create-k8s-cluster:
	minikube start $(MINIKUBE_WORKER_NODES) $(MINIKUBE_PROFILE)
#	TODO: needs optimizing
#	$(foreach addon, $(MINIKUBE_ADDONS), $(eval minikube addons enable $(addon) $(MINIKUBE_PROFILE)))
	minikube addons enable ingress $(MINIKUBE_PROFILE)
	minikube addons enable registry $(MINIKUBE_PROFILE)

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install kube-prometheus bitnami/kube-prometheus --namespace=monitoring -f helm/kube-prometheus/values.yaml

update-k8s-cluster:
#	#	TODO: needs optimizing
#	$(foreach addon, $(MINIKUBE_ADDONS), $(eval minikube addons enable $(addon) $(MINIKUBE_PROFILE)))
	minikube addons enable ingress $(MINIKUBE_PROFILE)
	minikube addons enable registry $(MINIKUBE_PROFILE)

	kubectl apply -f k8s/namespace/
	kubectl apply -f k8s/service/*

	helm upgrade kube-prometheus bitnami/kube-prometheus --namespace monitoring -f helm/kube-prometheus/values.yaml

	kubectl apply -f k8s/ingress/

delete-k8s-cluster:
	minikube delete $(MINIKUBE_PROFILE)

clean:
	minikube delete $(MINIKUBE_PROFILE)