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

main() {
  check_virtualization_support
  check_root
}
