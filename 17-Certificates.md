## Certificates

- **Certificate Authority (CA)** 
  - It is an entity that issues digital certificates. 
  - We will use [Let's Encrypt](https://letsencrypt.org/), which provides free TLS certificates and offers both a staging server for testing your certificate configuration, and a production server for rolling out verifiable TLS certificates.
- **Cert Manager** 
  - It is a Kubernetes add-on that provisions TLS certificates for CA's and manages their lifecycles.
  - It adds **certificates** and **certificate issuers** as resource types in Kubernetes clusters, and simplifies the process of obtaining, renewing and using those certificates. 
  - We will use [jetstack/cert-manager](https://github.com/jetstack/cert-manager) that is based on [cert-manager.io](https://cert-manager.io/)
- **Issuer**
  - It represents CA from which signed certificates can be obtained. There are different types of issuers as listed [here](https://cert-manager.io/docs/configuration/)
  - It is referenced by Certificate resources to generate signed certificates.
  - There are different issuer resources 
    - `Issuer`: It is scoped to a single namespace
    - `ClusterIssuer`: It is used for entire cluster 
  - We will use `ClusterIssuer` of `ACME Issuer type`
