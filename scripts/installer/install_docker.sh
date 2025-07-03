#!/bin/bash
set -e

apt_install(){
    sudo apt remove docker docker-engine docker.io containerd runc

    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] 、
        https://download.docker.com/linux/ubuntu $OS_CODENAME stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    # todo 添加apt 执行命令，上面语句也需要修改

}

dnf_install(){

}

do_install() {
    echo "docker安装脚本未完工，未执行任何操作"
    return
    case "$OS_NAME" in
        ubuntu|debian)
            apt_install
            ;;
        rhel|centos|fedora|amzn)
            # amzn 是 Amazon Linux 的 /etc/os-release 中的 ID
            dnf_install
            ;;
        *)
            echo "❌ 不支持的系统类型：$OS_NAME"
            return 1
            ;;
    esac
}

