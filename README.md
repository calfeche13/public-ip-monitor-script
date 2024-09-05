# Public IP Monitor Script

An OpenWrt service to monitor changes to the internet-facing public IP.

Check the [LuCI App Public IP Monitor](https://github.com/calfeche13/luci-app-public-ip-monitor) for the web interface manager.

## Motivation

Public IP Monitor was created to update AWS security group rules, specifically for allowing traffic from my home network. My goal is to maintain a continuous VPN connection between my OpenWrt router and an AWS server without exposing the VPN port to the public. This would enable me to do various things, such as hosting Jellyfin on my personal computer and allowing me and a long-distance loved one to watch movies or series together.

## Want to Support Me?

If you want me to continue making useful apps like this please support me through the links below :)

<a href="https://paypal.me/ChosenAlfeche"
    arget="_blank">
    <img src="READMEFILES/paypal.png"
        alt="Buy Me A Coffee"
        style="padding-right: 24px; height: 59px !important;width: 224px !important;" />
</a>

<a href="https://buymeacoffee.com/calfeche"
    target="_blank">
    <img src="READMEFILES/buy_me_a_coffee.png"
        alt="Buy Me A Coffee"
        style="padding-left: 8px; height: 73px !important;width: 224px !important;" />
</a>

## Setup

To install without building the app simply run the commands below.

```sh
# copy the contents of the root folder to othe root of openwrt
scp -r root/* root@<OpenWrt IP>:/

# execute the UCI defaults script to create the /etc/config/public_ip_monitor
ssh root@<OpenWrt IP> "sh /etc/uci-defaults/1301_public_ip_monitor"

# restart the public IPv4 monitor service
ssh root@<OpenWrt IP> "/etc/init.d/public_ip_monitor@ipv4 restart"

# restart the public IPv6 monitor service
ssh root@<OpenWrt IP> "/etc/init.d/public_ip_monitor@ipv6 restart"
```

The above command is useful during development. To actually build an IPK package for installation with opkg, refer to [BUILDING.md](BUILDING.md)

## UCI Options

### Monitoring Options

Enables/disables the monitoring of the public IP address.<br/>

Value is either 1 or 0.<br/>
Defaults is 0
```sh
public_ip_monitor.general.monitor_ipv4
public_ip_monitor.general.monitor_ipv6
```

### Public IP Service

Options specifies the service where we can get the public IP address.<br/>

Value is of type hostname.</br>
Default is [4.icanhazip.com](4.icanhazip.com) for IPv4</br>
Default is [6.icanhazip.com](6.icanhazip.com) for IPv6
```
public_ip_monitor.general.ipv4_ip_service
public_ip_monitor.general.ipv6_ip_service
```

### Check Interval

Below potioons specifies the interval of when to check for any public IP changes.</br>

Value is in seconds and has a type of integer.</br>
Default value is 30 seconds.
```sh
public_ip_monitor.general.ipv4_check_interval
public_ip_monitor.general.ipv6_check_interval
```

### Onchange Script Location
The location of the script to run when a change of public IP is detected.<br>

**_Note: IPv4 and IPv6 allows different scripts for flexibility but can make it so that both uses 1 script._**

```sh
public_ip_monitor.general.ipv4_script_location
public_ip_monitor.general.ipv6_script_location

```

### Current IP
This option holds the current public IP.

**_Note: Changing this will trigger the change detected._**

```sh
public_ip_monitor.ipv4.current
public_ip_monitor.ipv6.current
```

### History JSON

This is the path to the history.json file, where both IPv4 and IPv6 change histories are stored.

```sh
public_ip_monitor.general.history_location
```