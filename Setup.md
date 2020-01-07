### Setup Information

StudentGroup10
10
Port 1

Edge Router: 192.168.2.1
Switch: 10.0.0.1
PFSense external: 10.0.10.1
PFSense internal: 172.16.10.1
Sensor: 172.16.10.100

## Switch
Login::ssh perched@10.0.0.1 : perched1234!@#$  

### Configure terminal
1. Setup dhcp
- `config terminal`
- `ip dhcp excluded-address 10.0.10.0 10.0.10.1`
- `ip dhcp pool 10`
- `network 10.0.10.0 255.255.255.252`
- `default-router 10.0.10.1`
- `dns-server 192.168.2.1`
- `exit`
2. Setup VLANs
- `vlan 10`
- `name 10`
- `state active`
- `no shutdown`
- `exit`
3. Add interfaces
- `interface GigabitEthernet 1/0/1`
- `switchport`
- `switchport access vlan 10`
- `no shutdown`
- `exit`
- `interface vlan 10`
- `ip address 10.0.10.1 255.255.255.252`
- `no shutdown`
- `exit`
4. Enable static routes
- `ip routing`
- `ip route 172.16.10.0 255.255.255.0 10.0.10.2`

## PFSense
### Hardware setup
1. Boot into PFSense installer, difficult, not much time to get into boot menu
2. Normal install, use entire disk, GPT, reboot

### PFSense Config
|LAN4|LAN3|LAN2|LAN1|COM|
|---|---|---|---|---|
|en3|en2|en1|en0|local|

1 - assign interface
n - skip vlan Setup  
en0 - wan interfaces  
en1 - lan interfaces

2 - wan interfaces  
y - dhcp  
n - dhcp6  
blank for none  
y - http webconfig protocol  

2 - lan interface  
172.16.10.1/24  
blank for upstream gateway  
blank for ipv6
y - enable dhcp  
176.16.10.100 - start  
176.16.10.254 - end  
y - http webconfig protocol  

webconfig can be accessed from http://176.16.10.1/  

log in to PFSense webGUI  
admin : pfsense :: default
Hostname: SG10-pfsense  
Local Domain: local.lan  
Set edge rtr for DNS  
uncheck private networks on step 4  

Configure the Firewall  
Set an any/any rule on the WAN  
Disable NAT  

Enable additional interfaces as needed  
Verify one gateway  

### CentOS Networking
ip command, ifconfig gone  
1. Set IPV4  
ip address, ip a, ip add, etc  
vi the interface doc in /etc/sysconfig/network-scripts/ifcg-XXXXX  
Modify
- BOOTPROTO
- IPADDR
- PREFIX
- GATEWAY
- DNS1
- DNS2

systemctl restart network

2. Disable ipv6  
/etc/sysctl.conf
- net.ipv6.conf.all.disable_ipv6 = 1
- net.ipv6.conf.default.disable_ipv6 = 1
- net.ipv6.conf.lo.disable_ipv6 = 1  
load with sudo sysctl -p  
remove :: from /etc/hosts  

###Firewall Configuration

#### open / allow traffic  
sudo firewall-cmd --zone=public --add-ports=####/tcp --permanent  
sudo firewall-cmd --reload

#### close / deny traffic  
sudo firewall-cmd --zone=public --remove-port=####/tcp --permanent  
sudo firewall-cmd --reload

####commit all running firewall rules into the startup rules  
sudo firewall-cmd --runtime-to-permanent  

#### list all firewalld zones  
sudo firewall-cmd --list-all-zones  
sudo firewall-cmd --list-ports  
