if [ $# -ge 1 ]
then
	keys=`cat $1 |grep -v "^$\^#" |tr -t '\n' ' '`
else
	keys=`/usr/bin/salt-key -l unaccepted |grep -v "^Unaccepted Keys:$"`
	if [ `echo $keys |wc -c` -le 1 ]
	then
		keys=`/usr/bin/salt-key -l accepted |grep -v "^Accepted Keys:$"`
	else
		/usr/bin/salt-key -A -y
	fi
fi

echo $keys |sed "s/ /,/g" |while read ips
do
	echo "running:"
	echo "$ips" |sed "s/,/\n/g"
	salt -L "$ips" saltutil.refresh_pillar
	salt -L "$ips" state.sls common.salt-minion
	salt -L "$ips" state.highstate
done