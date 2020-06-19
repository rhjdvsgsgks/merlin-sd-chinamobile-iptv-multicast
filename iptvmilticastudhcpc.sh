#!/bin/sh

echo $1

setup_interface(){
	echo "ifconfig $interface $ip netmask $subnet"
	ifconfig $interface $ip netmask $subnet
}

setup_route(){
	#echo "ip route add default via $router dev $interface"
	#ip route add default via $router dev $interface
	echo "ip route replace default nexthop via $router dev $interface weight 1 nexthop via $(ip route|grep '^[0-9]'|grep ppp0|awk '{print $1}') dev ppp0 weight 1"
	ip route replace default nexthop via $router dev $interface weight 1 nexthop via $(ip route|grep '^[0-9]'|grep ppp0|awk '{print $1}') dev ppp0 weight 1
}

setup_iptables(){
	echo "iptables -t nat -A POSTROUTING ! -s $ip/32 -o $interface -j MASQUERADE"
	iptables -t nat -A POSTROUTING ! -s $ip/32 -o $interface -j MASQUERADE
}

restore_interface(){
	echo "ifconfig "$interface" 0.0.0.0"
	ifconfig "$interface" 0.0.0.0
}

restore_route(){
	echo "ip route replace default via $(ip route|grep '^[0-9]'|grep ppp0|awk '{print $1}') dev ppp0"
	ip route replace default via $(ip route|grep '^[0-9]'|grep ppp0|awk '{print $1}') dev ppp0
}

restore_iptables(){
	if [ ! -z "$(iptables-save |grep "\-A POSTROUTING ! \-s $(ip addr show|grep global|grep $interface|awk '{print $2}'|sed 's/\/.*//')/32 -o $interface -j MASQUERADE")" ]
	then
		#for i in $(iptables-save |grep ^'\-A POSTROUTING ! \-s'|grep "\-o $interface \-j MASQUERADE"$|awk '{print $5}')
		#do
		#	iptables -t nat -D POSTROUTING ! -s $i -o $interface -j MASQUERADE
		#done
		echo "iptables -t nat -D POSTROUTING ! -s $(ip addr show|grep global|grep $interface|awk '{print $2}'|sed 's/\/.*//')/32 -o $interface -j MASQUERADE"
		iptables -t nat -D POSTROUTING ! -s $(ip addr show|grep global|grep $interface|awk '{print $2}'|sed 's/\/.*//')/32 -o $interface -j MASQUERADE
	fi
}

case "$1" in
	deconfig)
		restore_iptables
		restore_route
		restore_interface
	;;
	renew)
		setup_interface
		setup_route
	;;
	bound)
		setup_interface
		setup_route
		setup_iptables
	;;
esac
