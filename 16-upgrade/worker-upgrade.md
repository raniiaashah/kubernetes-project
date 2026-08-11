# Worker Node Upgrade

## Overview
This document describes how to upgrade Kubernetes worker nodes after the control plane is upgraded.

## 1. Verify cluster state
- Ensure control plane nodes are healthy.
- Check the node list:
  ```bash
  kubectl get nodes
  ```

## 2. Drain the worker node
- Drain the worker node to evict workloads.
  ```bash
  kubectl drain <worker-node> --ignore-daemonsets --delete-local-data
  ```

## 3. Upgrade kubeadm, kubelet, and kubectl
- Install the same target version used on the control plane.
  ```bash
  sudo apt-get update
  sudo apt-get install -y kubeadm=<version> kubelet=<version> kubectl=<version>
  ```

## 4. Restart kubelet
- Reload the systemd configuration and restart kubelet.
  ```bash
  sudo systemctl daemon-reload
  sudo systemctl restart kubelet
  ```

## 5. Uncordon the worker node
- Allow workloads to be scheduled again.
  ```bash
  kubectl uncordon <worker-node>
  ```

## 6. Validate the worker node
- Verify the node is Ready and workloads are running.
  ```bash
  kubectl get nodes
  kubectl get pods -A --field-selector spec.nodeName=<worker-node>
  ```

## Notes
- Upgrade worker nodes one at a time.
- Use the same version for kubeadm, kubelet, and kubectl as the control plane.
