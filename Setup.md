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
