# k8s-gitops-env

This repository is the environment used to manage my k8s cluster. This is
currently a work in progress. This is closely related to the actual cluster
configuration and may get folded into that repo.

# Packages
These are the tools, clis, or libraries used to operate on the cluster:
 - [X] etcdctl
 - [ ] ceph cli
 - [ ] terraform cli
 - [X] ansible
 - [X] hostdb (ansible inventory from terraform)
 - [ ] fluxctl
 - [ ] kubectl
 - [ ] sops

# Data & Configuration

These pieces of data or configuration need to be fed into the environment to
be able to operate on the cluster:
 - [ ] gcloud auth: Terraform state, secret management?
 - [ ] proxmox password
 - [ ] ssh keys
 - [ ] kubernetes client certs
 - [ ] ansible inventory
 - [ ] sops keys