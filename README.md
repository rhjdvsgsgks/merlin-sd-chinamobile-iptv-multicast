# merlin-sd-chinamobile-iptv-multicast

山东移动 iptv 单线多拨，将 iptv 的带宽用作网速叠加， iptv 可正常使用

在破解移动送的 iptv 机顶盒时发现通过 ipoe+iptv 帐号居然可以访问非 iptv 的网站，于是就有了这个脚本

## 效果

使用后(上)/使用前(下)

![](https://raw.githubusercontent.com/rhjdvsgsgks/merlin-sd-chinamobile-iptv-multicast/master/Screenshot.png)

可以看出下行增加了150m上行增加了50m

## 使用方法

在光猫中记下所有 vlanid ，删除所有绑定配置，新建一个配置， bridge (桥接)，业务模式 Internet ，vlan transport (穿透)，关闭 dhcp

路由器中， lan 设置， iptv ，互联网填之前光猫中 internet 的 vlanid ， wan 设置正常拨号，请勿开启“双连接”

将 `iptvmilticast.sh` `iptvmilticastudhcpc.sh` 放入 `/jffs/scripts` 并设置权限，在 `iptvmilticast.sh` 中设置 iptv 的 vlanid (即光猫中 other 项的 vlanid ) 、 iptv 机顶盒的 mac 、 iptv 机顶盒使用 ipoe 方式连接时 dhcp 握手中 option60 项的值

执行 `iptvmilticast.sh` 即可
