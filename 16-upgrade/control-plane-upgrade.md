# Control Plane Upgrade

## Overview
This document describes the steps to upgrade Kubernetes control plane components safely.

## 1. Verify current cluster state
- Confirm all control plane nodes are Ready.
- Check the current Kubernetes version:
  ```bash
  kubectl version --short
  ```

## 2. Backup cluster state
- Backup etcd or use your backup solution.
- Save current control plane manifests and kubeconfig files.

## 3. Drain the control plane node (if multi-master)
- Use `kubectl drain` only if the node is schedulable.
  ```bash
  kubectl drain <control-plane-node> --ignore-daemonsets --delete-local-data
  ```

## 4. Upgrade kubeadm
- Install the target version of kubeadm on the control plane node.
  ```bash
  sudo apt-get update
  sudo apt-get install -y kubeadm=<version>
  ```

## 5. Plan the upgrade
- Run the upgrade plan to verify available versions.
  ```bash
  sudo kubeadm upgrade plan
  ```

## 6. Apply the upgrade
- Perform the control plane upgrade.
  ```bash
  sudo kubeadm upgrade apply <version>
  ```

## 7. Upgrade kubelet and kubectl
- Install matching kubelet and kubectl versions.
  ```bash
  sudo apt-get install -y kubelet=<version> kubectl=<version>
  sudo systemctl daemon-reload
  sudo systemctl restart kubelet
  ```

## 8. Uncordon the node
- Return the node to normal scheduling.
  ```bash
  kubectl uncordon <control-plane-node>
  ```

## 9. Validate cluster health
- Check node and pod status.
  ```bash
  kubectl get nodes
  kubectl get pods -A
  ```

## Notes
- Upgrade one control plane node at a time.
- Always match kubeadm, kubelet, and kubectl versions.
