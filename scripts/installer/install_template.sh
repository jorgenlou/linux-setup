#!/bin/bash
set -e

apt_install(){

}

dnf_install(){

}

do_install() {
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
