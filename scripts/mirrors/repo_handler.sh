#!/bin/bash
set -e


change_yum_repo() {
    if [[ $OS_NAME == "redhat" ]]; then
    echo "⚠️ 注意：该脚本未在Redhat系统测试，无法确定是否有效，操作前会备份原文件，如有问题可自行恢复"
    read -p "继续换源请输入 yes，否则取消操作: " choice
            case "$choice" in
                yes|YES) echo "将继续换源操作，由此引发的问题请自行负责";;
                *) echo "取消换源操作"; return;;
            esac
    fi

    echo "备份CentOS-Base.repo文件到/etc/yum.repos.d/CentOS-Base.repo.backup"
    sudo mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
        2>/dev/null || true
    echo "因社区停止维护，清华和中科大已放弃了对CentOS镜像源的支持，将使用阿里源"

    case "$OS_VERSION" in
        6)
            sudo curl -o /etc/yum.repos.d/CentOS-Base.repo \
                https://mirrors.aliyun.com/repo/Centos-vault-6.10.repo;;
        7)
            sudo curl -o /etc/yum.repos.d/CentOS-Base.repo \
                http://mirrors.aliyun.com/repo/Centos-7.repo;;
        8)
            sudo curl -o /etc/yum.repos.d/CentOS-Base.repo \
                https://mirrors.aliyun.com/repo/Centos-vault-8.5.2111.repo;;
    esac

    sudo yum clean all
    sudo yum makecache
}
