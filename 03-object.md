# Objects

- Kubernetes objects are **persistent entities** in the Kubernetes system. Kubernetes uses these entities to represent the state of your cluster.
- Every object created over the whole lifetime of a Kubernetes cluster has a distinct universally unique identifiers (also known as **UUIDs**) 
- A Kubernetes object is a **record of intent** or **specification**; once you create the object, the Kubernetes system will constantly work to ensure that object exists.
- By creating an object, you're effectively telling the Kubernetes system what you want your cluster's workload to look like; this is your cluster's **desired state**.
- Every object will have two nested object fields that govern the object's configuration: the object **spec**[desired stated] and the object **status**[current status].
- It is responsibility of k8 to actively manages every object's actual state to match the desired state you supplied. 
- **kubectl** command line interface(CLI) is used to create, modify, or delete Kubernetes objects. It will make necessary  Kubernetes API calls to manipulate k8 Objects.
- API request must include information as JSON in the request body. Most often, you provide the information to kubectl in a **.yaml** file. kubectl converts the information to JSON when making the API request.
- In the yaml file you'll need to set values for the following fields:
  - **apiVersion:** Which version of the Kubernetes API you're using to create this object.
  - **kind:** Type of object you want to create.
  - **metadata:** Data that helps uniquely identify the object, including a name string, UID, and optional namespace
  - **spec:** Describe the desire state of the object. This will be different from object to object
- User can also use REST API or Client Libraries to invoke changes.