# K3S Vargant cluster 

Kubernetes cluster based on vagrant VMs.

The cluster is composed of 1 master and 3 nodes.
Will be installed :
 - Helm
 - Traefik ingress controller
 - Ghost as example application

All-in-one : `./run.sh`

## Manual installation

```bash
# Start the VMs
vagrant up

#Install the k3s cluster
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini install.yml

#Install traefik
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini traefik.yml

#Install ghost
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini ghost.yml
```

## Access the cluster

The VMs are configured with these IPs :
 - kubemaster - 192.1268.10.10
 - kubenode1 - 192.1268.10.11
 - kubenode2 - 192.1268.10.12
 - kubenode3 - 192.1268.10.13