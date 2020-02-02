#!/bin/bash

set -eux

check_virtualization_support() {
  if ! grep -E --color 'vmx|svm' /proc/cpuinfo; then
    echo Virtualization is not supported on this machine.
    exit 1
  fi
}

check_root() {
  if ! [ ${EUID:-${UID}} = 0 ]; then
    echo "Please run with sudo."
    exit 1
  fi
}

install_kubectl() {
  apt-get update -y
  apt-get install -y apt-transport-https
  curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
  echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee -a /etc/apt/sources.list.d/kubernetes.list
  sudo apt-get update
  sudo apt-get install -y kubectl
}

main() {
  check_virtualization_support
  check_root

  install_kubectl
}
