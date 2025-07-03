#!/bin/bash
set -e

apt_install(){
    # ubuntu和debian
    curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | \
        sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/deb/nvidia-container-toolkit.list | \
    sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
    sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list

    sudo apt-get update

    export TOOLKIT_VERSION=1.17.8-1
    sudo apt-get install -y \
        nvidia-container-toolkit=${TOOLKIT_VERSION} \
        nvidia-container-toolkit-base=${TOOLKIT_VERSION} \
        libnvidia-container-tools=${TOOLKIT_VERSION} \
        libnvidia-container1=${TOOLKIT_VERSION}
}

dnf_install(){
    # RHEL、CentOS、Fedora、Amazon Linux
    curl -s -L https://nvidia.github.io/libnvidia-container/stable/rpm/nvidia-container-toolkit.repo | \
        sudo tee /etc/yum.repos.d/nvidia-container-toolkit.repo
    
    export TOOLKIT_VERSION=1.17.8-1
    sudo dnf install -y \
        nvidia-container-toolkit-${TOOLKIT_VERSION} \
        nvidia-container-toolkit-base-${TOOLKIT_VERSION} \
        libnvidia-container-tools-${TOOLKIT_VERSION} \
        libnvidia-container1-${TOOLKIT_VERSION}
}