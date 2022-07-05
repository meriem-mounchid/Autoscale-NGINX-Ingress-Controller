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
- List the Available Metrics: `kubectl get pods -o wide`

- Obtain the IP address of the NGINX Ingress Controller pod so that you can query its list of metrics.

```
NAME                                               READY   STATUS    RESTARTS        AGE   IP               NODE       NOMINATED NODE   READINESS GATES
main-nginx-ingress-b79c6fff9-s2fmt                 1/1     Running   0               22h   172.17.0.4       minikube   <none>           <none>
```

- Create a temporary BusyBox:
```
kubectl run -ti --rm=true busybox --image=busybox  
If you don't see a command prompt, try pressing enter. 
/ # 
```
```
/# wget -qO- <IP_address>:9113/metrics
```
IP_address: 172.17.0.4 (NGINX Ingress Controller pod)

- Deploy Prometheus:

Run:`helm repo add prometheus-community https://prometheus-community.github.io/helm-charts`
Run:`helm install prometheus prometheus-community/prometheus --set server.service.type=NodePort --set server.service.nodePort=30010`

```
kubectl get pods
NAME                                               READY   STATUS             RESTARTS         AGE
main-nginx-ingress-b79c6fff9-s2fmt                 1/1     Running            0                22h
podinfo-5d76864686-r8dmh                           1/1     Running            0                22h
prometheus-alertmanager-67dfc6ff85-k7r56           2/2     Running            0                22h
prometheus-kube-state-metrics-748fc7f64-4z5st      1/1     Running            20 (131m ago)    22h
prometheus-node-exporter-wj894                     1/1     Running            0                22h
prometheus-pushgateway-6df8cfd5df-zc6tt            1/1     Running            8                22h
prometheus-server-6bd8b49ff8-n2lnt                 1/2     CrashLoopBackOff   15 (4m51s ago)   22h
```

- Open Prometheus Dashboard in Default Browser: `minikube service --all`

```
|-----------|---------------------------------|--------------|-----------------------------|
| NAMESPACE |              NAME               | TARGET PORT  |             URL             |
|-----------|---------------------------------|--------------|-----------------------------|
| default   | main-nginx-ingress              | http/80      | http://192.168.59.153:30005 |
|           |                                 | https/443    | http://192.168.59.153:30644 |
| default   | podinfo                         |           80 | http://192.168.59.153:30001 |
| default   | prometheus-alertmanager         | No node port |
| default   | prometheus-kube-state-metrics   | No node port |
| default   | prometheus-node-exporter        | No node port |
| default   | prometheus-pushgateway          | No node port |
| default   | prometheus-server               | http/80      | http://192.168.59.153:30010 |
|-----------|---------------------------------|--------------|-----------------------------|
```
<img width="641" alt="Screen Shot 2022-07-05 at 2 24 17 PM" src="https://user-images.githubusercontent.com/43518207/177338444-14180b29-c792-42b7-91f8-d0fb48d3b6ee.png">

- Type nginx_ingress_nginx_connections_active in the search bar to see the current value of the active connections metric.

- Install Locust:
Run: `kubectl apply -f locust.yaml`

- Open Locust in a browser: `minikube service --all`
```
|-----------|---------------------------------|--------------|-----------------------------|
| NAMESPACE |              NAME               | TARGET PORT  |             URL             |
|-----------|---------------------------------|--------------|-----------------------------|
| default   | kubernetes                      | No node port |
| default   | locust                          |         8089 | http://192.168.59.153:30015 |
| default   | main-nginx-ingress              | http/80      | http://192.168.59.153:30005 |
...
```
<img width="635" alt="Screen Shot 2022-07-05 at 2 29 10 PM" src="https://user-images.githubusercontent.com/43518207/177339370-fab6545f-6a4c-43fe-b599-60c8ef458190.png">

- Enter the following values in the fields:

```
Number of users – 1000
Spawn rate – 10
Host – http://main-nginx-ingress
```

- Click the Start swarming button to send traffic to the Podinfo app.

- Return to the Prometheus dashboard to see how NGINX Ingress Controller responds. You may have to perform a new query for nginx_ingress_nginx_connections_active to see any change.

### 4. Autoscale NGINX Ingress Controller

- Install KEDA:

Run: `helm repo add kedacore https://kedacore.github.io/charts`
Run: `helm install keda kedacore/keda`

```
kubectl get pods 
NAME                                               READY   STATUS             RESTARTS         AGE
keda-operator-7879dcd589-mz64f                     1/1     Running            21 (3m30s ago)   22h
keda-operator-metrics-apiserver-54746f8fdc-gr5rx   1/1     Running            16 (8m14s ago)   22h
locust-77c699c94d-tpkd8                            1/1     Running            0                22h
main-nginx-ingress-b79c6fff9-s2fmt                 1/1     Running            0                22h
podinfo-5d76864686-r8dmh                           1/1     Running            0                22h
prometheus-alertmanager-67dfc6ff85-k7r56           2/2     Running            0                22h
prometheus-kube-state-metrics-748fc7f64-4z5st      1/1     Running            27 (53s ago)     22h
prometheus-node-exporter-wj894                     1/1     Running            0                22h
prometheus-pushgateway-6df8cfd5df-zc6tt            1/1     Running            13 (3m9s ago)    22h
prometheus-server-6bd8b49ff8-n2lnt                 1/2     Running            17 (7m4s ago)    22h
```

- Create an Autoscaling Policy:

Run: `kubectl apply -f scaled-object.yaml`

- Return to the Locust server in your browser. Enter the following values in the fields and click the Start swarming button:
```
Number of users – 2000
Spawn rate – 10
Host – http://main-nginx-ingress
```

- Return to the Prometheus and Locust dashboards. The pink box under the Prometheus graph depicts the number of NGINX Ingress Controller pods scaling up and down.

- Simulate a Traffic Surge and Observe the Effect of Autoscaling on Performance:

Run: `kubectl get hpa`

Done!!!




