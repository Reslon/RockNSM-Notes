# Networking Basics

### Switch

### Vlans
- VLAN == virtual lan in older days of physical switch seperation provediced network segmention
- VLAN tag == numeric ID
- switch intercommunication happens of trunk ports

### Routering
- layer 3 - IP address
- used to move traffic from one subnet, vlan, or broadcast domain to another
- when you need to move up from layer 2
- router fires and forgets
- how does router decide upon best interface to send?
- Connected route
 - ip on rtr
 - manual input
 - trusted
- dynamically learned
 - routing protocol
 - adjust to topology
 - rtr share info or routes they've learned

### Subinterfaces
- routers cannot use trunk ports
- solution: subinterface - the VLAN of the router world
```
switch - seperation -> WLAN  
router - serperation -> subinterface
```
- best practices
 - Match VLAN anConfigd subinterface

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

#### ports
firewall-cmd --add-port=<port>/<type> --permanent

### Sockets  
##### What is a Socket  
- IP / port / protocol defined to provide a connection / service  
- ss is the new hotness
- ss -int : shows all listening sockets
