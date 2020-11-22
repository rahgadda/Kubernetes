# Object Management:

- There are three types of k8 Object Management
  - **Imperative Commands:**
    - In this process kubectl command direct work on the objects without any configuration files      
    `kubectl create deployment nginx --image nginx` 
  - **Imperative Object Configuration:**
    - In this process kubectl command work on configuration file and not on folder of config files   
    ```sh
    kubectl create -f nginx.yaml
    kubectl delete -f nginx.yaml -f redis.yaml
    kubectl replace -f nginx.yaml
    ```
  - **Declarative Object Configuration**
    - In this process kubectl command work on configuration of config files. 
    - In below `diff` is used to see what changes are going to be made
    - Filter `-R` is used to recursively parse all the folders and identify config files and apply changes.
    ```sh
    kubectl diff -R -f configs/
    kubectl apply -R -f configs/
    ```

## Namespaces:
- Kubernetes supports multiple virtual clusters backed by the same physical cluster. These virtual clusters are called **namespaces**. 
- Avoid creating namespace with prefix **kube-**, since it is reserved for Kubernetes system namespaces.
- Kubernetes starts with four initial namespaces:
  - **default:** The default namespace for objects with no other namespace
  - **kube-system:** The namespace for objects created by the Kubernetes system.
  - **kube-public:** This namespace is created automatically and is readable by all users (including those not authenticated). This namespace is mostly reserved for cluster usage, in case that some objects should be visible and readable publicly throughout the whole cluster. The public aspect of this namespace is only a convention, not a requirement.
  - **kube-node-lease:** This namespace for the lease objects associated with each node which improves the performance of the node heartbeats as the cluster scales.
- Most Kubernetes objects (e.g. pods, services, replication controllers, and others) are in some namespaces. 
- However namespace objects are not themselves in a namespace. 
- Low-level objects, such as nodes and persistentVolumes, are not in any namespace.
  ```sh
  # Create a namespace
  kubectl create namespace demo-namespace
  # Working with namespaces
  kubectl config set-context --current --namespace=demo-namespace
  kubectl config view --minify | grep namespace:
  # List all namespaces
  kubectl get namespace
  # Describe a namespace
  kubectl describe namespace demo-namespace
  # Pods inside a namespace
  kubectl run nginx --image=nginx --namespace=demo-namespace
  kubectl get pods --namespace=demo-namespace
  # Objects Stored in namespaces
  kubectl api-resources --namespaced=true
  # Objects Not Stored in namespaces
  kubectl api-resources --namespaced=false
  # Delete namespaces
  kubectl delete namespace demo-namespace
  ```

## Labels
- Labels are key/value pairs that are attached to objects. These are similar to tags.
- Valid label keys have two segments: an optional prefix and name, separated by a slash (/). 
  - The prefix must be a DNS subdomain: a series of DNS labels separated by dots (.), not longer than 253 characters in total, followed by a slash (/).
    - If the prefix is omitted, the label Key is presumed to be private to the user.
    - The `kubernetes.io/` and `k8s.io/` prefixes are reserved for Kubernetes core components.
  - The name segment is required and must be 63 characters or less, beginning and ending with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between. 
- Valid label values must be 63 characters or less and must be empty or begin and end with an alphanumeric character ([a-z0-9A-Z]) with dashes (-), underscores (_), dots (.), and alphanumerics between.
- Labels allow for efficient queries and watches and are ideal for use in UIs and CLIs.
  ```json
  "metadata": {
    "labels": {
      "key1" : "value1",
      "key2" : "value2"
    }
  }
  ```
- Unlike names and UIDs, labels do not provide uniqueness. In general, we expect many objects to carry the same label(s).

## Label Selectors
- The label selector is the core grouping primitive in Kubernetes.
- Using label selector, the client/user can identify a set of objects.
- A label selector can be made of multiple requirements which are comma-separated. In the case of multiple requirements, all must be satisfied so the comma separator acts as a logical AND (&&) operator.
- There are two types of selectors: equality-based and set-based.
  - **equality-based:** 
    - Three kinds of operators are used `=,==,!=`.
    ```yaml
    nodeSelector:
      environment = production, tier != frontend
    ```
  - **set-based:**  
    - Three kinds of operators are supported: `in, notin and exist`
    ```yaml
    nodeSelector:
      environment in (production, qa), tier notin (frontend, backend)
    ```
- Label Selectors can be used in listing/watching/filtering the sets of objects returned using a query parameter. 
  `kubectl get pods -l environment=production,tier=frontend`
- Some Kubernetes objects, such as **services** and **replicationcontrollers**, also use label selectors to specify sets of other objects. These only support **equality-based**.
  ```json
  "selector": {
      "component" : "redis",
  }
  ```
- Newer Kubernetes Objects, such as Job, Deployment, ReplicaSet, and DaemonSet, support both **equality-based** and **set-based**
  ```yaml
  selector:
    matchLabels:
      component: redis
    matchExpressions:
      - {key: tier, operator: In, values: [cache]}
      - {key: environment, operator: NotIn, values: [dev]}
  ```

## Field Selectors
- Used to filter k8 object attributes. Field selectors are essentially resource filters. 
- By default, no selectors/filters are applied, meaning that all resources of the specified type are selected.
  ```sh
  # No Field Selector
  kubectl get pods 
  
  # Has Field Selector
  kubectl get pods --field-selector ""
  ```
- Three kinds of operators are used `=,==,!=`.
  ```sh
  kubectl get pods,statefulsets,services --all-namespaces --field-selector=metadata.namespace!=default,spec.restartPolicy=Always
  ```

## Annotations 
- Kubernetes labels and annotations are both ways of adding metadata to Kubernetes objects.
- Kubernetes labels allow you to identify, select and operate on Kubernetes objects. Annotations are non-identifying metadata and do none of these things.
- Annotations allow you to add non-identifying metadata to Kubernetes objects. Examples include phone numbers of persons responsible for the object or tool information for debugging purposes. Build number associated with each deployment.
- In short, annotations can hold any kind of information that is useful and can provide context to DevOps teams.
  ```json
  "metadata": {
    "annotations": {
      "key1" : "value1",
      "key2" : "value2"
    }
  }
  ```
- Naming convention constructs are similar to Labels.