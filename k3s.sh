#!/bin/bash

set -eux

# minikubeのバージョンは下記一覧から選択
# https://github.com/kubernetes/minikube/releases
MINIKUBE_VER=1.6.2

check_virtualization_support() {
  if ! grep -E --color 'vmx|svm' /proc/cpuinfo; then
    echo Virtualization is not enabled on this machine.
    exit 1
  fi

  if ! [ $(command -v virt-host-validate) ]; then
    apt-get update -y
    apt-get install -y libvirt-clients
  fi
  virt-host-validate
}

check_root() {
  if ! [ ${EUID:-${UID}} = 0 ]; then
    echo "Please run with sudo."
    exit 1
  fi
}

install_kubectl() {
  apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list
  apt-get update -y
  apt-get install -y kubectl
}

add_kubectl_completion() {
  kubectl completion bash >/etc/bash_completion.d/kubectl
}

install_minikube() {
  wget https://github.com/kubernetes/minikube/releases/download/v$MINIKUBE_VER/minikube_$MINIKUBE_VER.deb
  dpkg -i minikube_$MINIKUBE_VER.deb
}

cleanup() {
  rm -f minikube_$MINIKUBE_VER.deb
}

main() {
  check_root
  apt-get update -y
  check_virtualization_support

  install_kubectl
  add_kubectl_completion
  install_minikube

  cleanup
}
