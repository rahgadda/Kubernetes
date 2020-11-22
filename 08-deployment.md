# Deployments

- A Deployment provides declarative updates for **Pods** and **ReplicaSets**.
- We describe a desired state in a Deployment, and the Deployment Controller changes the actual state to the desired state at a controlled rate.
- If you update a Deployment while an existing rollout is in progress, the Deployment creates a **new ReplicaSet** as per the update and start **scaling that up**, it will add **previous ReplicaSets** to its list of old ReplicaSets and start **scaling it down**.
- The only difference between a **paused** Deployment and one that is not paused, is that any changes into the PodTemplateSpec of the paused Deployment will not trigger new rollout as long as it is paused. 
  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: nginx-deployment
    labels:
      app: nginx
  spec:
    replicas: 3
    selector:
      matchLabels:
        app: nginx
    template:
      metadata:
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx:1.14.2
          ports:
          - containerPort: 80
  ```
  ```sh
  # Update deployment image
  kubectl --record deployment.apps/nginx-deployment set image deployment.v1.apps/nginx-deployment nginx=nginx:1.16.1
  kubectl set resources deployment.v1.apps/nginx-deployment -c=nginx --limits=cpu=200m,memory=512Mi

  # Display Rollout Status
  kubectl rollout status deployment.v1.apps/nginx-deployment
  kubectl rollout history deployment.v1.apps/nginx-deployment
  kubectl rollout pause deployment.v1.apps/nginx-deployment

  # Rollback deployment
  kubectl rollout undo deployment.v1.apps/nginx-deployment
  kubectl rollout undo deployment.v1.apps/nginx-deployment --to-revision=2

  # Scaling deployment
  kubectl scale deployment.v1.apps/nginx-deployment --replicas=10
  kubectl autoscale deployment.v1.apps/nginx-deployment --min=10 --max=15 --cpu-percent=80
  ```
- 