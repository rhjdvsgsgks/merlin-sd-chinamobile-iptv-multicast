# merlin-sd-chinamobile-iptv-multicast

山东移动 iptv 单线多拨，将 iptv 的带宽用作网速叠加， iptv 可正常使用

在破解移动送的 iptv 机顶盒时发现通过 ipoe+iptv 帐号居然可以访问非 iptv 的网站，于是就有了这个脚本

## 效果

使用后(上)/使用前(下)

![](https://raw.githubusercontent.com/rhjdvsgsgks/merlin-sd-chinamobile-iptv-multicast/master/Screenshot.png)

可以看出下行增加了150m上行增加了50m

## 使用方法

在光猫中记下所有 vlanid ，删除所有绑定配置，新建一个配置， bridge (桥接)，业务模式 Internet ，vlan transport (穿透)，关闭 dhcp ，什么端口都不绑定

光猫随便找个 lan 口接上路由器(建议 lan1 ，其他接口可能偷工减料不是千兆)， iptv 机顶盒随便怎么接无论有线无线只要接上路由器并在 lan 段即可

路由器中， lan 设置， iptv ，互联网 vid 填之前光猫中 internet 的 vlanid ， wan 设置 pppoe (其他方式接口名称可能不同，把所有 ppp0 替换成该连接方式的接口名称即可)，请勿开启“双连接”

将 `iptvmilticast.sh` `iptvmilticastudhcpc.sh` 放入 `/jffs/scripts` 并设置权限，在 `iptvmilticast.sh` 中设置 iptv 的 vlanid (即光猫中 other 项的 vlanid ) 、 iptv 机顶盒的 mac 、 iptv 机顶盒使用 ipoe 方式连接时 dhcp 握手中 option60 项的值

将 `/jffs/scripts/iptvmilticast.sh` 添加到 `/jffs/scripts/nat-start` 重启即可

## 已知 bug

抓包获取的 option60 有有效期，过期后无法获取新ip

## TODO

- [ ] 自动抓取来自机顶盒的 dhcp 包提取并更新 option60
