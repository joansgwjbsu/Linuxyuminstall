#!/bin/bash
#Author:root
#Version:1.0.0.1
#Mail:
#Date:2026-04-10
#最后一次更改日期:2026-04-13
#建立变量
YumNAME=rockylinux9.repo
YumPATH=/etc/yum.repos.d/
YumSRC=/dev/sr0
YumMOUNT=/media/cdrom
YumENTREPOT=AppStream
YumENTREPOB=BaseOS
YumENTREPOGPG=0
YumENTREPOE=1
#使用脚本创建本地yum源
cd "$YumPATH" || exit
echo "查看当前工作目录"
if grep -r "^baseurl=file://" "$YumPATH" &>/dev/null; then
	echo '已配置本地yum源'
else
	echo '未配置本地yum源,正在配置本地yum源'
	pwd
	echo "查看当前目录下的文件"
	ls
	echo "创建备份目录"
	mkdir -p bak
	echo "查看当前目录下的文件"
	ls
	echo "备份当前yum源"
	mv *.repo bak
	echo "创建新的yum源文件"
	cat >"$YumNAME" <<EOF
[$YumENTREPOT]
name=$YumENTREPOT
baseurl=file://$YumMOUNT/$YumENTREPOT
gpgcheck=$YumENTREPOGPG
enabled=$YumENTREPOE
[$YumENTREPOB]
name=$YumENTREPOB
baseurl=file://$YumMOUNT/$YumENTREPOB
gpgcheck=$YumENTREPOGPG
enabled=$YumENTREPOE
EOF
fi
echo "查看当前目录下的文件"
ls
echo "查看以.repo结尾的文件内容"
cat "$YumNAME" 2>/dev/null
if [ ! -d YumMOUNT ]; then
	echo "创建挂载点"
	mkdir -p YumMOUNT
fi
echo "挂载光盘"
if mount | grep -q YumMOUNT; then
	echo '已挂载'
else
	if mount "$YumSRC" "$YumMOUNT" &>/dev/null; then
		echo '挂载成功'
	else
		echo '挂载失败'
		exit 1
	fi
fi
echo "清除yum缓存,并构建元缓存"
dnf clean all 
#dnf makecache 
#初次建立仓库将 dnf makecache 前的注释取消
echo '查看仓库'
dnf repolist
