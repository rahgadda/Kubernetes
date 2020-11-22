# ReplicaSet

- It is used to maintain a stable set of replica Pods running at any given time.
- A ReplicaSet is defined with below fields
  - A selector that specifies how to identify Pods it can acquire.
  - A number of replicas indicating how many Pods it should be maintaining.
  - A pod template specifying the data of new Pods it should create to meet the number of replicas criteria.
- ReplicaSet is not limited to owning Pods specified by its template; it can acquire other Pods with same label selectors.
- A ReplicaSet is linked to its Pods via the Pods' **metadata.ownerReferences** field, which specifies what resource the current object is owned by.
- All Pods acquired by a ReplicaSet have their owning ReplicaSet's identifying information within their ownerReferences field.
- A **Deployment** is a higher-level concept that manages ReplicaSets and provides declarative updates to Pods along with a lot of other useful features.
    ```yaml
    apiVersion: apps/v1
    kind: ReplicaSet
    metadata:
    name: frontend
    labels:
        app: guestbook
        tier: frontend
    spec:
    # modify replicas according to your case
    replicas: 3
    selector:
        matchLabels:
        tier: frontend
    template:
        metadata:
        labels:
            tier: frontend
        spec:
        containers:
        - name: php-redis
            image: gcr.io/google_samples/gb-frontend:v3

    ```
- We can delete a ReplicaSet without affecting any of its Pods using `kubectl delete` with the `--cascade=false` option.
- We can remove Pods from a ReplicaSet by changing their labels.
- A ReplicaSet can also be used with **Horizontal Pod Autoscalers (HPA)** or **Deployments**