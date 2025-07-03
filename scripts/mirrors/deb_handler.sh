#!/bin/bash
set -e

select_fastest_mirror(){
    # 选择响应最快的镜像源地址
    mirrors=(
        "http://cn.archive.ubuntu.com/ubuntu"
        "https://mirrors.tuna.tsinghua.edu.cn"
        "https://mirrors.ustc.edu.cn"
        "https://mirrors.aliyun.com"
    )

    mirror_names=("ubuntu" "tsinghua" "ustc" "aliyun")

    FASTEST_MIRROR="${mirrors[0]}"  # 默认源
    FASTEST_TIME=5000  # 毫秒，初始为一个较大的值

    echo ""
    echo "🌐 测速镜像源响应速度..."

    for i in "${!mirrors[@]}"; do
        url="${mirrors[$i]}"
        name="${mirror_names[$i]}"

        # 使用 || true 实现局部禁用 set -e，避免curl请求超时导致脚本退出
        result=$(
            curl -s -o /dev/null -w "%{http_code} %{time_total}" --connect-timeout 5 "$url" || true)
        read -r code time <<< "$result"

        if [[ "$code" == "200" ]]; then
            ms=$(awk "BEGIN {printf \"%d\", $time * 1000}")
            echo "✅ 访问 $name ($url) 成功，耗时：${ms} ms"
            if [[ "$ms" -lt "$FASTEST_TIME" ]]; then
                FASTEST_TIME="$ms"
                FASTEST_MIRROR="$url"
            fi
        else
            echo "❌ 访问 $name ($url) 失败，状态码: $code"
        fi
    done

    echo -e "\n🚀 将默认使用最快镜像源：$FASTEST_MIRROR"

    echo ""
    echo "如果你想使用指定源，请选择编号："
    for i in "${!mirrors[@]}"; do
        echo "$((i+1)). ${mirror_names[$i]} (${mirrors[$i]})"
    done
    echo "按回车跳过并使用默认源"

    read -p "你的选择 [1-${#mirror_names[@]}]: " choice
    if [[ "$choice" =~ ^[1-${#mirror_names[@]}]$ ]]; then
        USED_MIRROR="${mirrors[$((choice-1))]}"
        echo "📦 使用手动选择镜像源：$USED_MIRROR"
    else
        USED_MIRROR="$FASTEST_MIRROR"
        echo "📦 使用测速最快镜像源：$USED_MIRROR"
    fi

    # 去掉尾部斜杠
    USED_MIRROR="${USED_MIRROR%/}"
    export USED_MIRROR
}


change_apt_source(){
    # 获取源地址
    select_fastest_mirror

    echo ""
    echo "🧩 是否添加源码仓库（deb-src）？"
    echo "👉 一般普通软件安装不需要，只有开发系统工具包或需要手动编译系统包时才需要。"
    echo "⏳ [3秒内输入 y 安装并按回车，添加源码仓库（deb-src）]，否则不添加"
    read -t 3 -p ">： " answer  || true
    case "$answer" in
        y|Y) WITH_SRC=true;;
        *) WITH_SRC=false;;
    esac

    # 校验变量是否定义
    : "${OS_NAME:?❌ 错误：变量 OS_NAME 未定义}"
    : "${OS_CODENAME:?❌ 错误：变量 OS_CODENAME 未定义}"
    : "${USED_MIRROR:?❌ 错误：变量 USED_MIRROR 未定义}"

    echo -e "\n📌 当前配置如下："
    echo "系统类型：$OS_NAME"
    echo "系统代号: $OS_CODENAME"
    echo "源地址位：$USED_MIRROR"
    echo "添加源码仓库: $WITH_SRC"
    echo "⏳ [5秒内输入 q 取消]，否则将继续换源:"
    read -t 5 -p "> " answer
    case "$answer" in
        q|Q) echo "❌ 换源操作已停止"; return;;
    esac
    echo ""
    echo "✅ 开始执行换源操作..."
    echo -e "\n🔧 正在写入 /etc/apt/sources.list..."

    # 备份旧 sources.list
    sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

    # 构造新源内容
    main_line="deb $USED_MIRROR/$OS_NAME/ $OS_CODENAME main restricted universe multiverse"
    updates_line="deb $USED_MIRROR/$OS_NAME/ $OS_CODENAME-updates main restricted universe multiverse"
    security_line="deb $USED_MIRROR/$OS_NAME/ $OS_CODENAME-security main restricted universe multiverse"
    backports_line="deb $USED_MIRROR/$OS_NAME/ $OS_CODENAME-backports main restricted universe multiverse"

    # 源文件写入
    {
        echo "$main_line"
        echo "$updates_line"
        echo "$security_line"
        echo "$backports_line"

        if $WITH_SRC; then
            echo ""
            echo "${main_line/deb /deb-src }"
            echo "${updates_line/deb /deb-src }"
            echo "${security_line/deb /deb-src }"
            echo "${backports_line/deb /deb-src }"
        fi
    } | sudo tee /etc/apt/sources.list > /dev/null

    echo -e "\n🔄 更新本地软件索引中..."
    sudo apt-get update -y
    echo "✅ 换源完成！"
}
