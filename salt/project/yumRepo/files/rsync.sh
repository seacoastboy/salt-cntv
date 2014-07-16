#!/bin/bash

excludeList="/usr/local/cntv/yumSync/exclude.list"

rsync -rltzP --delete --exclude-from=$excludeList rsync://mirrors.ustc.edu.cn/centos/ /repo/centos/
rsync -rltzP --delete --exclude-from=$excludeList rsync://mirrors.ustc.edu.cn/epel/ /repo/epel/

chmod 755 /repo/epel -R
chmod 755 /repo/centos -R

#cat $excludeList |grep -v "^$\|^#" |while read line
#do
#	find /repo/centos/ -wholename "*${line}" -exec rm -rf {} \;
#	find /repo/epel/ -wholename "*${line}" -exec rm -rf {} \;
#done