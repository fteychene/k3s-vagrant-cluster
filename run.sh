#!/bin/env bash

echo "Starting machines"
vagrant up

echo "Install kubernetes cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini install.yml

# kubectl --kubeconfig=fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml get nodes -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}:{range .status.conditions[*]}{.type}={.status};{end}{end}'
until [ $(kubectl --kubeconfig=fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml get nodes | grep Ready | wc -l) -ge 4 ]
do
    echo Nodes not ready yet
    sleep 5
done

echo "Wait a little for the cluster to be stable"
sleep 60


echo "Install traefik in cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini traefik.yml

echo "Install ghost helm chart in cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini ghost.yml

echo "Kube config is available in => fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml"


echo "Add to /etc/hosts"
echo "192.168.10.10 traefik.dash"
echo "192.168.10.10 ghost.kube"
echo
echo "export KUBECONFIG=fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml to use the cluster"