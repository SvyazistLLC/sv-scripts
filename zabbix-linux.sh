#!/bin/sh

dir=/etc/zabbix/zabbix_agentd.d/
hostname=$(</etc/hostname)
agentdConf=/etc/zabbix/zabbix_agentd.conf


GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'


[ -d $dir ]  || mkdir -p  $dir

echo '''PidFile=/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix-agent/zabbix_agentd.log
LogFileSize=0
ListenPort=10050
ListenIP=0.0.0.0
ServerActive=127.0.0.1
Include=/etc/zabbix/zabbix_agentd.d/*.conf
Timeout=5
Server=192.168.0.0/16''' > $agentdConf

echo "Hostname=${hostname}" >> $agentdConf


echo """# This is a configuration file for Template Linux Disk Performance itmicus.ru
############ GENERAL PARAMETERS #################
UserParameter=custom.vfs.dev.discovery,DEVS=`grep -E -v 'fd|loop|ram|sr|major|^$|dm-' /proc/partitions|awk '{if($2==0||($2%8==0))print $4}'|sed 's/\//\!/g'`;POSITION=1;echo "{";echo " \"data\":[";for DEV in $DEVS;do if [ $POSITION -gt 1 ];then echo -n ",";fi;echo -n " { \"{#DEVICENAME}\": \"$DEV\"}";POSITION=`expr $POSITION + 1`;done;echo "";echo " ]";echo "}"
UserParameter=custom.vfs.dev.read.ops[*],awk '{print $$1}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.merged[*],awk '{print $$2}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.sectors[*],awk '{print $$3}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.read.ms[*],awk '{print $$4}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ops[*],awk '{print $$5}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.merged[*],awk '{print $$6}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.sectors[*],awk '{print $$7}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.write.ms[*],awk '{print $$8}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.active[*],awk '{print $$9}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.io.ms[*],awk '{print $$10}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.weight.io.ms[*],awk '{print $$11}' /sys/class/block/$1/stat
# discards
UserParameter=custom.vfs.dev.discards.ops[*],awk '{if($$12=="")print 0;else print $$12;}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.discards.merged[*],awk '{if($$13=="")print 0;else print $$13;}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.discards.sectors[*],awk '{if($$14=="")print 0;else print $$14;}' /sys/class/block/$1/stat
UserParameter=custom.vfs.dev.discards.ms[*],awk '{if($$15=="")print 0;else print $$15;}' /sys/class/block/$1/stat
# MD Raid
UserParameter=md.discover,ls /sys/class/block | awk 'BEGIN{printf "{\"data\":["}; /md/ {printf c"{\"{#MDNAME}\":\""$1"\"}";c=","}; END{print "]}"}'
UserParameter=md.degraded[*],cat /sys/block/$1/md/degraded
UserParameter=md.sync_action[*],cat /sys/block/$1/md/sync_action
UserParameter=md.raid_disks[*],cat /sys/block/$1/md/raid_disks""" > /etc/zabbix/zabbix_agentd.d/os_linux_disk_performance.conf.conf

echo """# This is a configuration file for Template Linux Memory itmicus.ru
############ GENERAL PARAMETERS #################
UserParameter=custom.meminfo.discovery,cat /proc/meminfo""" > /etc/zabbix/zabbix_agentd.d/os_linux_memory.conf

echo """# This is a configuration file for Template Linux Network itmicus.ru
############ GENERAL PARAMETERS #################
# if ethtool installed
UserParameter=custom.netif.ethtool[*],ethtool $1 2>/dev/null || echo "N/A"
#https://www.kernel.org/doc/Documentation/ABI/testing/sysfs-class-net
UserParameter=custom.netif.speed[*],cat /sys/class/net/$1/speed 2>/dev/null || echo 0
UserParameter=custom.netif.carrier[*],cat /sys/class/net/$1/carrier 2>/dev/null || echo 0
UserParameter=custom.netif.operstate[*],cat /sys/class/net/$1/operstate 2>/dev/null || echo -1
UserParameter=custom.netif.name_assign_type[*],cat /sys/class/net/$1/name_assign_type 2>/dev/null || echo 0
UserParameter=custom.netif.addr_assign_type[*],cat /sys/class/net/$1/addr_assign_type 2>/dev/null || echo 0
UserParameter=custom.netif.address[*],cat /sys/class/net/$1/address 2>/dev/null || echo "N/A"
UserParameter=custom.netif.dev_id[*],cat /sys/class/net/$1/dev_id 2>/dev/null || echo "N/A"
UserParameter=custom.netif.duplex[*],cat /sys/class/net/$1/duplex 2>/dev/null || echo "N/A"
UserParameter=custom.netif.type[*],cat /sys/class/net/$1/type 2>/dev/null || echo -1
UserParameter=ip_conntrack_max,test -f /proc/sys/net/netfilter/nf_conntrack_max && cat /proc/sys/net/netfilter/nf_conntrack_max || 0""" > /etc/zabbix/zabbix_agentd.d/os_linux_network.conf



printf  "${GREEN}Check zabbix_agentd file settings ${RED} ${agentdConf}${NC} ${NC}\n"
