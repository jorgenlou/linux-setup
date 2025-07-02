#!/bin/bash

load_os_release() {
    if [ -z "$__OS_RELEASE_LOADED" ]; then
        if [ -f /etc/os-release ]; then
            source /etc/os-release
            __OS_RELEASE_LOADED=1
        else
            echo "⚠️ 无法加载 /etc/os-release"
        fi
    fi
}

get_os_info() {
    load_os_release
    if [ -n "$ID" ]; then
        OS_NAME=$ID
        OS_VERSION=$VERSION_ID
        OS_CODENAME=$VERSION_CODENAME
        echo "🧭 自动检测系统成功，发行版本：$OS_NAME ($OS_VERSION / $OS_CODENAME)"
    else
        echo "⚠️ 无法自动识别系统信息"
        manual_os_name
        manual_os_version
        manual_os_codename
    fi
}


manual_os_name() {
    load_os_release
    if [ -n "$ID" ]; then
        OS_NAME=$ID
        echo "🧭 自动检测系统成功，发行版本：$OS_NAME"
    else
        echo "⚠️ 系统类型识别失败，请手动选择您的 Linux 系统类型（输入数字选择或 e 退出）："
        echo "1:Ubuntu 2:Debian 3:CentOS 4:RedHat e:退出"
        while true; do
            read -p "你的选择: " choice
            case "$choice" in
                1) OS_NAME="ubuntu"; break;;
                2) OS_NAME="debian"; break;;
                3) OS_NAME="centos"; break;;
                4) OS_NAME="redhat"; break;;
                e|E) echo "👋 退出"; exit 0;;
                *) echo "❌ 无效选择，请输入 1/2/3/4/e";;
            esac
        done
        echo "✅ 手动选择系统：$OS_NAME"
    fi
}

manual_os_version() {
    load_os_release
    if [ -n "$VERSION_ID" ]; then
        OS_VERSION=$VERSION_ID
        echo "🧭 自动检测系统版本成功：$OS_VERSION"
    else
        read -p "版本号检测失败请输入: " OS_VERSION
    fi
}

manual_os_codename() {
    load_os_release
    if [ -n "$VERSION_CODENAME" ]; then
        OS_CODENAME=$VERSION_CODENAME
        echo "🧭 自动检测系统代号成功：$OS_CODENAME"
    else
        read -p "版本代号检测失败请输入: " OS_CODENAME
    fi
}
