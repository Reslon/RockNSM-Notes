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
