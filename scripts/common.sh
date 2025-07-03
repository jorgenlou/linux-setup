#!/bin/bash
set -e

load_os_release() {
    if [ -z "$__OS_RELEASE_LOADED" ]; then
        if [ -f /etc/os-release ]; then
            source /etc/os-release
            __OS_RELEASE_LOADED=1
        else
            echo "⚠️ 无法加载文件 /etc/os-release，将进入手动设置模式"
        fi
    fi
}

get_os_info() {
    echo ""
    echo "🔎 检测系统版本信息"
    manual_os_name "no echo"
    manual_os_version "no echo"
    manual_os_codename "no echo"
    echo "🧭 检测成功，系统版本为：$OS_NAME-$OS_VERSION ($OS_CODENAME)"
}


manual_os_name() {
    load_os_release
    if [ -n "$ID" ]; then
        OS_NAME=$ID
    else
        echo "⚠️ 未检测到系统发行版本，请手动选择（输入数字选择或 q 退出）："
        echo "1:Ubuntu 2:Debian 3:CentOS 4:RedHat q:退出"
        while true; do
            read -p "你的选择: " choice
            case "$choice" in
                1) OS_NAME="ubuntu"; break;;
                2) OS_NAME="debian"; break;;
                3) OS_NAME="centos"; break;;
                4) OS_NAME="redhat"; break;;
                q|Q) echo "👋 退出"; exit 0;;
                *) echo "❌ 无效选择，请输入 1/2/3/4/q";;
            esac
        done
    fi
    if [ -z "$1" ]; then
        echo "📌 发行版本为：$OS_NAME"
    fi
    export OS_NAME
}

manual_os_version() {
    load_os_release
    if [ -n "$VERSION_ID" ]; then
        OS_VERSION=$VERSION_ID
    else
        read -p "版本号检测失败请输入: " OS_VERSION
    fi
    if [ -z "$1" ]; then
        echo "📌 版本号为：$OS_VERSION"
    fi
    export OS_VERSION
}

manual_os_codename() {
    load_os_release
    if [ -n "$VERSION_CODENAME" ]; then
        OS_CODENAME=$VERSION_CODENAME
    else
        read -p "版本代号检测失败请输入: " OS_CODENAME
    fi
    if [ -z "$1" ]; then
        echo "📌 版本代号为：$OS_CODENAME"
    fi
    export OS_CODENAME
}
