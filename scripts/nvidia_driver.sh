#!/bin/bash
set -e

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
source "$DIR/common.sh"

# 待验证
apt install ubuntu-drivers-common
ubuntu-drivers devices
apt install nvidia-driver
