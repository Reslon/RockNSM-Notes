# Sensor Configuration Information

### Repo Setup
In PFSense services > dns resolver > general > edit host  
Add the hostname to resolve and the IP address of the laptop repos  
```
host : <name>
domain: local.lan
ip: x.x.x.x
```

Make modification ifcfg DNS1 172.

`sudo systemctl restart network` to restart the network  
