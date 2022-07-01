# Autoscale-NGINX-Ingress-Controller
Reducing Kubernetes Latency with Autoscaling
### 1. Configure a Simple App on a Kubernetes Cluster
- Create a Minikube Cluster:
<img width="517" alt="Screen Shot 2022-07-01 at 2 36 54 PM" src="https://user-images.githubusercontent.com/43518207/176905549-5271cf5c-c547-4c7b-9a43-5aae2940aacb.png">

- Install the Podinfo App: `kubectl apply -f deploy_pulp.yaml`
<img width="484" alt="Screen Shot 2022-07-01 at 2 38 43 PM" src="https://user-images.githubusercontent.com/43518207/176905836-758bc2da-ca62-4aec-9e6c-fdc1701b2836.png">

- Run: `kubectl get pods`
<img width="562" alt="Screen Shot 2022-07-01 at 2 40 02 PM" src="https://user-images.githubusercontent.com/43518207/176906156-a72d0e5c-f030-4a20-81f1-17217bd67c29.png">

- Run: `minikube service --all`
<img width="513" alt="Screen Shot 2022-07-01 at 3 38 49 PM" src="https://user-images.githubusercontent.com/43518207/176915912-3ead62f8-21af-4f81-87fa-d5a7347afc54.png">

![Screen_Shot_2022-07-01_at_15 41 30](https://user-images.githubusercontent.com/43518207/176916462-e99e08ce-6ba5-4193-9882-926617aad985.png)

### 2. Use NGINX Ingress Controller to Route Traffic to the App
- Add Nginx repo to Helm: `helm repo add nginx-stable https://helm.nginx.com/stable`
<img width="552" alt="Screen Shot 2022-07-01 at 3 47 12 PM" src="https://user-images.githubusercontent.com/43518207/176917393-95374e33-8805-4d50-a311-788d1ee02c02.png">

- Install NGINX Ingress Controller:
```
helm install main nginx-stable/nginx-ingress --set controller.watchIngressWithoutClass=true --set controller.service.type=NodePort --set controller.service.httpPort.nodePort=30005
```
<img width="594" alt="Screen Shot 2022-07-01 at 3 49 50 PM" src="https://user-images.githubusercontent.com/43518207/176917827-44d3bdf4-e301-46e8-9354-db60aca293b4.png">

- To confirm deployment run: `kubectl get pods`
<img width="624" alt="Screen Shot 2022-07-01 at 3 51 26 PM" src="https://user-images.githubusercontent.com/43518207/176918270-e05a8b3f-3454-4e3d-8d20-87de97a594ef.png">

- Deploy the Ingress file: `kubectl apply -f ingress_pulp.yaml`
<img width="580" alt="Screen Shot 2022-07-01 at 3 55 14 PM" src="https://user-images.githubusercontent.com/43518207/176918842-48cb620e-1dc7-4c04-8596-30b88db87067.png">



### 3. Generate and Monitor Traffic
### 4. Autoscale NGINX Ingress Controller
