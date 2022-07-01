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

### 3. Generate and Monitor Traffic
### 4. Autoscale NGINX Ingress Controller
