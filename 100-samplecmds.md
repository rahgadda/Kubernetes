# Kubernetes

## Basics
- Basic Commands
  ```bash
  $ kubectl cluster-info
  # Display resources available on Kubernetes
  $ kubectl explain <resource_type>
  # This will return all resources of the type you're supplying
  $ kubectl get <resource_type>
  # Create all file in directory
  $ kubectl create -f <file>/<directory>
  # apply - makes incremental changes to an existing object                     [DeclarativeManagement]
  # create - creates a whole new object (previously non-existing / deleted)     [ImperativeManagement]
  $ kubectl apply -f <file>/<directory>
  # Update running container
  $ kubectl edit <resource_type> <resource_name>
  # Describe a running resource
  $ kubectl describe <resource_type> <resource_name_actual>/<creation_name>
  $ kubectl get nodes -o wide
  $ kubectl get nodes -o yaml
  $ kubectl get nodes -o json
  # kubectl run nginx --image=nginx --port=80
  $ kubectl run <name> --image=<container-image> --port=<container-port>
  # Get all STDIN and STDOUT logs
  $ kubectl logs -p <Pod Name> -c <Container>
  # Kubernetes maintains a timeline of all events that are created.
  $ kubectl get events
  # Set environment variables to a pod using deployment
  $ kubectl set env deployment/code-server --list -n code-server
  # Safely evict all of your pods from a node before you perform maintenance on the node
  $ kubectl drain 10.0.10.4 10.0.12.4 10.0.11.5
 
  # List all k8 objects/primitives
  $ kubectl api-resources -o name
  ```