#!/bin/bash
set -e

initialize() {
    # >>> conda initialize >>>
    # !! Contents within this block are managed by 'conda init' !!
    __conda_setup="$('/opt/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
    if [ $? -eq 0 ]; then
        eval "$__conda_setup"
    else
        if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
            . "/opt/miniconda3/etc/profile.d/conda.sh"
        else
            export PATH="/opt/miniconda3/bin:$PATH"
        fi
    fi
    unset __conda_setup
    # <<< conda initialize <<<
}

apt_install(){
    wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -P cache
    bash cache/Miniconda3-latest-Linux-x86_64.sh
}

dnf_install(){
    apt_install
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
