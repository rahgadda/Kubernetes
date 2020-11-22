# ReplicationController

- ReplicaSets are the successors to ReplicationControllers. It has same documentation details as ReplicaSets.
- ReplicaSets and ReplicationControllers serve the same purpose, and behave similarly, except that a ReplicationController does not support **set-based** label selector.
- A ReplicationController ensures that a specified number of pod replicas are running at any one time.
  ```yaml
  apiVersion: v1
  kind: ReplicationController
  metadata:
    name: nginx
  spec:
    replicas: 3
    selector:
      app: nginx
    template:
      metadata:
        name: nginx
        labels:
          app: nginx
      spec:
        containers:
        - name: nginx
          image: nginx
          ports:
          - containerPort: 80
  ```