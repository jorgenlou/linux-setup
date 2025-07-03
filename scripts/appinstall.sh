#!/bin/bash
set -e

# 获取当前脚本的绝对路径
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/common.sh"

if [ -z "$OS_NAME" ]; then
    echo "获取系统版本信息"
    get_os_info
fi

case "$OS_NAME" in 
    ubuntu|debian)
        source "$DIR/installer/apt_install.sh"
        ;;
    centos|redhat)
        source "$DIR/installer/yum_install.sh"
        ;;
esac
