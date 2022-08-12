MINIKUBE_CONFIG_CPUS	= 2
MINIKUBE_CONFIG_RAM		= 4096

MINIKUBE_PROFILE 		= -p sandbox
MINIKUBE_WORKER_NODES 	= --nodes 2
MINIKUBE_ADDONS			= ingress

update-minikube-config:
	minikube config set driver docker

	minikube config set cpus $(MINIKUBE_CONFIG_CPUS)
	minikube config set memory $(MINIKUBE_CONFIG_RAM)

create-minikube-cluster:
	minikube start $(MINIKUBE_WORKER_NODES) $(MINIKUBE_PROFILE)
	minikube addons enable ingress $(MINIKUBE_PROFILE)
	minikube addons enable metrics-server $(MINIKUBE_PROFILE)
	minikube addons enable dashboard $(MINIKUBE_PROFILE)

	kubectl apply -f k8s/namespace/
	kubectl apply -f k8s/service/echo/

	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm install kube-prometheus bitnami/kube-prometheus --namespace=monitoring -f helm/kube-prometheus/values.yaml

	helm repo add k8s-at-home https://k8s-at-home.com/charts/
	helm install heimdall k8s-at-home/heimdall --namespace heimdall -f helm/heimdall/values.yaml

	kubectl apply -f k8s/ingress/

update-minikube-cluster:
	minikube addons enable ingress $(MINIKUBE_PROFILE)
	minikube addons enable metrics-server $(MINIKUBE_PROFILE)
	minikube addons enable dashboard $(MINIKUBE_PROFILE)

	kubectl apply -f k8s/namespace/
	kubectl apply -f k8s/service/echo/

	helm upgrade kube-prometheus bitnami/kube-prometheus --namespace monitoring -f helm/kube-prometheus/values.yaml
	helm upgrade heimdall k8s-at-home/heimdall --namespace heimdall -f helm/heimdall/values.yaml

	kubectl apply -f k8s/ingress/

delete-minikube-cluster:
	minikube delete $(MINIKUBE_PROFILE)

clean:
	minikube delete $(MINIKUBE_PROFILE)