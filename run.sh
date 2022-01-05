#!/bin/env bash

setup_colors() {
  if [[ -t 2 ]] && [[ -z "${NO_COLOR-}" ]] && [[ "${TERM-}" != "dumb" ]]; then
    NOFORMAT='\033[0m' RED='\033[0;31m' GREEN='\033[0;32m' ORANGE='\033[0;33m' BLUE='\033[0;34m' PURPLE='\033[0;35m' CYAN='\033[0;36m' YELLOW='\033[1;33m'
  else
    NOFORMAT='' RED='' GREEN='' ORANGE='' BLUE='' PURPLE='' CYAN='' YELLOW=''
  fi
}

cleanup() {
  trap - SIGINT SIGTERM ERR EXIT
  # script cleanup here
}

msg() {
  echo >&2 -e "${1-}"
}

setup_colors
cleanup

msg "${NOFORMAT}Starting machines"
vagrant up

msg "${NOFORMAT}Install kubernetes cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini install.yml

# kubectl --kubeconfig=fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml get nodes -o jsonpath='{range .items[*]}{"\n"}{.metadata.name}:{range .status.conditions[*]}{.type}={.status};{end}{end}'
until [ $(kubectl --kubeconfig=fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml get nodes | grep Ready | wc -l) -ge 4 ]
do
    msg "${YELLOW}Nodes not ready yet"
    sleep 5
done

msg "${CYAN}Wait 1m for the cluster to be stable"
sleep 60


msg "${NOFORMAT}Install traefik in cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini traefik.yml

msg "${NOFORMAT}Install ghost helm chart in cluster"
ANSIBLE_HOST_KEY_CHECKING=false ansible-playbook --inventory-file=inventory/vagrant/hosts.ini ghost.yml

msg "${GREEN}Installation successful"
msg
msg "${CYAN}Add to /etc/hosts"
msg "${CYAN}192.168.10.10 traefik.dash"
msg "${CYAN}192.168.10.10 ghost.kube"
msg "${CYAN}192.168.10.10 kubemaster"
msg
msg "${CYAN}Kube config is available in => $(pwd)/fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml"
msg "${CYAN}export KUBECONFIG=$(pwd)/fetched/kubemaster/etc/rancher/k3s/k3s-external.yaml to use the cluster"