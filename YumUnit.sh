#!/bin/bash
#Author:root
#Version:1.0.0.1
#Mail:
#Date:2026-04-10
#最近一次更改日期:2026-04-13
#建立变量
YumPATH=/etc/yum.repos.d/
YumMOUNT=/media/cdrom
YumFile="file://$YumMOUNT"
YumPath="$YumPATH/rockylinux9.repo"
#删除本地yum
echo '备份原有yum源'
cd "$YumPATH" || exit 1
ls "*.repo" &>/dev/null && tar -czvf "/backup/Yum_Backup$(date +%s).tar.gz" ./*.repo
echo '正在删除本地yum源'
if grep -q "baseurl=$YumFile" "$YumPath" &>/dev/null; then
	echo '已配置本地yum源'
else
	echo '未配置本地yum源,无需删除'
	exit 0
fi
if mount | grep -q "$YumMOUNT"; then
	echo '已挂载'
	echo '正在取消挂载'
	umount "$YumMOUNT"
else
	echo '未挂载'
fi
rm -f "$YumPath"
echo "查看本地yum源是否删除成功"
if [ ! -f "$YumPath" ]; then
	echo "本地yum源删除成功"
else
	echo "本地yum源删除失败"
	exit 1
fi
