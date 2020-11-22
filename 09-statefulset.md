# StatefulSet

- A StatefulSet is another Kubernetes controller that manages pods just like **Deployments**.
- Unlike Deployments, StatefulSet is more suited for stateful apps. It provides guarantees about the ordering and uniqueness of these Pods.
  ```yaml
  apiVersion: apps/v1
  kind: StatefulSet
  metadata:
    name: web
  spec:
    selector:
      matchLabels:
        app: nginx # has to match .spec.  template.metadata.labels
    serviceName: "nginx"
    replicas: 3 # by default is 1
    template:
      metadata:
        labels:
          app: nginx # has to match .spec.  selector.matchLabels
      spec:
        terminationGracePeriodSeconds: 10
        containers:
        - name: nginx
          image: k8s.gcr.io/nginx-slim:0.8
          ports:
          - containerPort: 80
            name: web
          volumeMounts:
          - name: www
            mountPath: /usr/share/nginx/html
    volumeClaimTemplates:
    - metadata:
        name: www
      spec:
        accessModes: [ "ReadWriteOnce" ]
        storageClassName: "my-storage-class"
        resources:
          requests:
            storage: 1Gi
  ```
- A StatefulSet maintains a sticky identity for each of their Pods. These pods are created from the same spec, but are not interchangeable.
  - Stable, unique pod identifiers. For a StatefulSet with N replicas, when Pods are being deployed, they are created sequentially, in order from {0..N-1}
  - Stable, unique network identifiers.
  - Stable, persistent storage.
  - Ordered, graceful deployment and scaling. When Pods are being deleted, they are terminated in reverse order, from {N-1..0}.
  - Ordered, automated rolling updates.
- Limitations:
  - The storage for a given Pod must either be provisioned by a PersistentVolume Provisioner or pre-provisioned by an admin.
  - Deleting and/or scaling a StatefulSet down will not delete the volumes associated with the StatefulSet.
  - StatefulSets requires a Headless Service to be responsible for the network identity of the Pods.
  - StatefulSets do not provide any guarantees on the termination of pods when a StatefulSet is deleted.
- 