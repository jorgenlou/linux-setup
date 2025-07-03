#!/bin/bash
set -e

# 获取当前脚本的绝对路径
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# 颜色输出函数
yellow() { echo -e "\033[1;33m$1\033[0m"; }

# 初始化
packages=(
    "ca-certificates" "curl" "gnupg" "apt-transport-https"
    "git" "vim" "aptitude" "openssh-server" "podman"
    "nvidia-container-toolkit"
)
declare -A custom_install_scripts=(
    [nvidia-container-toolkit]="install_nvidia_toolkit.sh"
)

install_packages=()
install_scripts=()
installed=()

echo "🔍 检查以下软件是否已安装..."

for pkg in "${packages[@]}"; do
    if dpkg -s "$pkg" &>/dev/null; then
        installed+=("$pkg")
    else
        echo ""
        yellow "📦 未安装软件：$pkg"
        echo "❓ 是否安装？[y:安装，n:跳过，默认跳过]"
        read -t 5 -p "> 你的选择 (5秒后自动跳过): " choice || true
        case "$choice" in
            y|Y) 
                if [[ -v custom_install_scripts["$pkg"] ]]; then
                    install_scripts+=("${custom_install_scripts[$pkg]}")
                else
                    install_packages+=("$pkg")
                fi
            ;;
            # 输入其它值则跳过安装
            *) 
                if [ -z "$choice" ]; then
                    echo ""
                fi
                echo "⏩ 跳过 $pkg"
            ;;
        esac

    fi
done

echo ""
echo "✅ 已安装的软件包："
printf "  - %s\n" "${installed[@]}"

if [ ${#install_packages[@]} -gt 0 ]; then
    echo -e "\n📥 即将安装的软件包："
    printf "  - %s\n" "${install_packages[@]}"
    echo -e "\n🔄 开始执行安装..."
    sudo apt-get update -qq
    sudo apt-get install -y "${install_packages[@]}"
    echo "✅ 所有缺失的软件包已安装完成。"
else
    echo -e "\n✅ 无需安装其他软件包。"
fi

for script in "${install_scripts[@]}"; do 
    echo -e "\n🔄 开始执行安装脚本 $script"
    script_path="$DIR/$script"
    if [[ -f "$script_path" ]]; then
        source "$script_path"
        do_install
    else
        echo "❌ 安装脚本不存在: $script_path，跳过"
    fi
done

# 输出总结
echo ""
[ ${#installed[@]} -gt 0 ] && echo "✅ 已安装软件：${installed[*]}"
[ ${#install_packages[@]} -gt 0 ] && echo "📦 需要 apt 安装：${install_packages[*]}"
[ ${#install_scripts[@]} -gt 0 ] && echo "🧩 需要脚本安装：${install_scripts[*]}"

