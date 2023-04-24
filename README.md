# k8s-gitops-env

This repository is the environment used to manage my k8s cluster. This is
currently a work in progress. This is closely related to the actual cluster
configuration and may get folded into that repo.

# Packages
These are the tools, clis, or libraries used to operate on the cluster:
 - [X] etcdctl
 - [X] ceph cli
 - [X] terraform cli
 - [X] ansible
 - [X] hostdb (ansible inventory from terraform)
 - [ ] fluxctl
 - [X] kubectl
 - [ ] sops

# Data & Configuration

These pieces of data or configuration need to be fed into the environment to
be able to operate on the cluster:
 - [X] gcloud auth: Terraform state, secret management?
 - [X] proxmox password
 - [X] ssh keys
 - [ ] kubernetes client certs
 - [X] ansible inventory
 - [ ] sops keys

## Ceph Client

Following the [Basic Ceph Client Setup](https://docs.ceph.com/en/quincy/cephadm/client-setup/) there
are two parts needed to be mounted in `/etc/` in the container. These are paced in `.env` for easy
mounting in the devcontainer.

From an existing host, obtain a `ceph.conf`:
```
$ sudo ceph config generate-minimal-conf
# minimal ceph.conf for ....
[global]
	fsid = ...
	mon_host = [v2:1.2.3.4:3300/0,v1:1.2.3.4:6789/0] [v2:4.3.2.1:3300/0,v1:4.3.2.1:6789/0]
```

And a `ceph.keyring`:
```
$ sudo ceph auth get-or-create client.admin
[client.admin]
	key = ....
```
