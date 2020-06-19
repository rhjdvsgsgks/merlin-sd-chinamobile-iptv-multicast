#!/bin/sh

vlanid=
mac=00:00:00:00:00:00
option60=0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

#if [ "$(ifconfig eth0.v$vlanid)" != "ifconfig: eth0.v$vlanid: error fetching interface information: Device not found" ]
#then
#	vlanctl --if-delete eth0.v$vlanid
#fi
#vlanctl --mcast --if-create eth0 $vlanid
#vlanctl --if eth0 --rx --tags 1 --filter-vid $vlanid 0 --pop-tag --set-rxif eth0.v$vlanid --rule-append
#vlanctl --if eth0 --tx --tags 0 --filter-txif eth0.v$vlanid --push-tag --set-vid $vlanid 0 --rule-append
#ifconfig eth0.v$vlanid hw ether $mac
#ifconfig eth0.v$vlanid allmulti up
#for i in $(pidof udhcpc)
#do
#	if [ "$(cat /proc/$i/cmdline|tr '\0' ' '|sed 's/ $//')" = "/sbin/udhcpc -i eth0.v$vlanid -p /var/run/udhcpc1.pid -s /jffs/scripts/iptvmilticastudhcpc.sh -x 0x3c $option60" ]
#	then
#		echo "kill $i"
#		kill $i
#	fi
#done
#/sbin/udhcpc -i eth0.v$vlanid -p /var/run/udhcpc1.pid -s /jffs/scripts/iptvmilticastudhcpc.sh -x 0x3c $option60

if [ "$(ifconfig vlan$vlanid)" != "ifconfig: vlan$vlanid: error fetching interface information: Device not found" ]
then
	vconfig rem vlan$vlanid
fi
vconfig add eth0 $vlanid
ifconfig vlan$vlanid hw ether $mac
ifconfig vlan$vlanid allmulti up
for i in $(pidof udhcpc)
do
	if [ "$(cat /proc/$i/cmdline|tr '\0' ' '|sed 's/ $//')" = "/sbin/udhcpc -i vlan$vlanid -p /var/run/udhcpc1.pid -s /jffs/scripts/iptvmilticastudhcpc.sh -x 0x3c $option60" ]
	then
		echo "kill $i"
		kill $i
	fi
done
/sbin/udhcpc -i vlan$vlanid -p /var/run/udhcpc1.pid -s /jffs/scripts/iptvmilticastudhcpc.sh -x 0x3c $option60
