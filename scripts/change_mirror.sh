#!/bin/bash

source ./scripts/common.sh

codename=$(lsb_release -cs)
ali="http://mirrors.aliyun.com/ubuntu/"
tsinghua="https://mirrors.tuna.tsinghua.edu.cn/help/ubuntu"

echo -e "change apt source\n0 no change\n1 select ali (default)\n2 select tsinghua"
read -p "chosen:" option

if [[ -z "$option" || $option -eq 1 ]]
then
    option=1
    url=$ali
elif [[ $option -eq 2 ]]
then
    url=$tsinghua
fi

if [[ $option != 0 ]]
cp /etc/apt/sources.list /etc/apt/sources.list.bak

aptSource="deb $url $codename main restricted universe multiverse\n\
deb-src $url $codename main restricted universe multiverse\n\n\
deb $url $codename-security main restricted universe multiverse\n\
deb-src $url $codename-security main restricted universe multiverse\n\n\
deb $url $codename-updates main restricted universe multiverse\n\
deb-src $url $codename-updates main restricted universe multiverse\n\n\
deb $url $codename-proposed main restricted universe multiverse\n\
deb-src $url $codename-proposed main restricted universe multiverse\n\n"
then
  if [[ "$codename" = "bionic" ]] #ubuntu 18
  then
    str="deb $url $codename-backports main restricted universe multiverse\n\
deb-src $url $codename-backports main restricted universe multiverse"
    echo -e $aptSource$str > /etc/apt/sources.list
  elif [[ "$codename" = "xenial" ]] #ubuntu 16
  then
    echo -e $aptSource > /etc/apt/sources.list
  fi
  apt-get update
fi
