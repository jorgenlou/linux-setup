#!/bin/bash
set -e

source common.sh

if [ -z "$OS_NAME" ]; then
    echo "获取系统版本信息"
    get_os_info
fi

case "$OS_NAME" in
    # ubuntu和debian换源
    ubuntu|debian) 
        source ./mirrors/deb_handler.sh
        change_apt_source
        ;;
    # centos和redhat换源
    centos|redhat)
        source ./mirrors/repo_handler.sh
        change_yum_repo
        ;;
    *)
        echo "❌ 当前系统 $OS_NAME 暂不支持自动换源"
        ;;
esac


