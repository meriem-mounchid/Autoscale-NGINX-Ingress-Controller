build:
	kubectl apply -f deploy_pulp.yaml
	helm repo add nginx-stable https://helm.nginx.com/stable
	helm install main nginx-stable/nginx-ingress --set controller.watchIngressWithoutClass=true --set controller.service.type=NodePort --set controller.service.httpPort.nodePort=30005
	kubectl apply -f ingress_pulp.yaml
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm install prometheus prometheus-community/prometheus --set server.service.type=NodePort --set server.service.nodePort=30010
	kubectl apply -f locust.yaml
	helm repo add kedacore https://kedacore.github.io/charts
	helm install keda kedacore/keda
	kubectl apply -f scaled-object.yaml
	
	
	minikube service --all	
	
clean:
	kubectl delete --all pods --namespace=default
	kubectl delete --all deployments --namespace=default
	kubectl delete --all services --namespace=default
	kubectl delete --all daemonset --namespace=default
	helm ls --all --short | xargs -L1 helm delete

