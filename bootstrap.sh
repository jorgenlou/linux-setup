#!/bin/bash
set -e

source ./scripts/common.sh

echo "============================="
echo "🧰 Linux Setup"
echo "============================="

# 1. 交互式选择系统
get_os_info

# 2. 交互式选择要安装的模块
echo ""
echo "请选择要安装的组件（可多选，用空格分隔）："
echo "1) 切换软件源"
echo "2) 安装基础软件"
echo "3) 安装 NVIDIA 驱动"
echo "q) 退出"

while true; do
    read -p "请输入你要执行的操作编号: " modules
    case "$modules" in
        1)
            source ./scripts/change_mirror.sh
            ;;
        2)
            source ./scripts/appinstall.sh
            ;;
        3)
            source ./scripts/nvidia_driver.sh
            ;;

        q|Q) echo "👋 退出"; exit 0;;
        *) echo "❌ 无效选择，请输入 1/2/3/q";;
    esac
done
