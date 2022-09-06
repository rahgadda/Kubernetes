# Cilium

## Overview
- `Cilium` is `open source software` for transparently securing the `network connectivity` between application services deployed using Linux container management platforms like `Docker` and `Kubernetes`.
- At the foundation of Cilium is a new Linux kernel technology called `eBPF`, which enables the dynamic insertion of powerful security visibility and control logic within Linux itself.
- `eBPF` runs inside the `Linux kernel`, this helps Cilium security policies can be applied and updated without any changes to the application code or container configuration.
- `Hubble` is a fully `distributed networking and security observability` platform built on top of Cilium to enable deep visibility into the communication and behavior of services as well as the networking infrastructure in a completely transparent manner.

## eBPF
- `eBPF` was first created in 2014. `Cilium` was first created in 2016.
- 

## Commands
- Command to review Kubernetes Pod Networking. List all IP Tables for KUBE-SERVICE and review IP Tables for each service. 
    ```sh
    sudo iptables -n -t nat - L KUBE-SERVICE
    sudo iptables -n -t nat - L KUBE-SERVICE-XXXXX
    ```

# Reference
- [Official Documentation](https://docs.cilium.io/en/stable/gettingstarted/)
- [eBPF](https://ebpf.io/)
- [Video 1](https://www.youtube.com/watch?v=aLq3O3l2LF4), [Video 2](https://www.youtube.com/watch?v=5EcVrm01rAU), [Video 3](https://www.youtube.com/watch?v=gkrPt0ZcCfo)