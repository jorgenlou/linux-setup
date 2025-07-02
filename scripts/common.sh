#!/bin/bash

detect_os() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        OS_NAME=$ID
        echo "🧭 自动检测系统成功：$OS_NAME"
    else
        echo "⚠️ 无法自动识别系统类型，进入手动选择模式..."
        manual_os_selection
    fi
}

manual_os_selection() {
    echo ""
    echo "请选择你的 Linux 发行版（输入数字或输入 e 退出）："
    echo "1:Ubuntu 2:Debian 3:CentOS 4:RedHat e:退出安装"
    while true; do
        read -p "你的选择: " choice
        case "$choice" in
            1)
                OS_NAME="ubuntu"
                break
                ;;
            2)
                OS_NAME="debian"
                break
                ;;
            3)
                OS_NAME="centos"
                break
                ;;
            4)
                OS_NAME="redhat"
                break
                ;;
            e|E)
                echo "👋 退出安装"
                exit 0
                ;;
            *)
                echo "❌ 无效选择，请输入 1/2/3/4/e"
                ;;
        esac
    done
    echo "✅ 手动选择系统：$OS_NAME"
}
