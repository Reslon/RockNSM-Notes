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

### Setup SSH


### Setting up Google Stenographer
1. Run `sudo yum install Stenographer`  
Config files will be stored in /etc/stenographer  
2. `vi /etc/stenographer/config` and modify it to match
```
{
  "Threads": [
    { "PacketsDirectory": "/data/stenography/thread0/packets/directory"
    , "IndexDirectory": "/data/stenography/thread0/index/directory"
    , "MaxDirectoryFiles": 30000
    , "DiskFreePercentage": 10
    }
  ]
  , "StenotypePath": "/usr/bin/stenotype"
  , "Interface": "em1"
  , "Port": 1234
  , "Host": "127.0.0.1"
  , "Flags": []
  , "CertPath": "/etc/stenographer/certs"
}
```
- The pwd needs to accurately reflect the location stenographer is writing to.  
3. Run `stenokeys.sh stenographer stenographer` to create the certs that stenographer needs to work.  
4. Verify stenographer has rights to the stenography partition/folder. Use `chown -R <user>: <pwd>`, ie `chown -R stenographer: /data/stenography`  
5. Start stenography with `systemctl start stenographer`  
- If an error is 'not doing anything', permissions may be incorrectly set.
- If an error is failure to start processes, wrong directories may be listed.  
- Packets are written to pwd/thread0/packets/directory.
6. After verifying stenographer runs, stop the service.
7. Using ethtool running the following set of commands to ensure as much information is pulled on each packet as possible.
```
ethtool -K enp0s31f6 tso off gro off lro off gso off rx off tx off sg off rxvlan off txvlan off
ethtool -N enp0s31f6 rx-flow-hash udp4 sdfn
ethtool -N enp0s31f6 rx-flow-hash udp6 sdfn
ethtool -C enp0s31f6 adaptive-rx off
ethtool -C enp0s31f6 rx-usecs 1000
ethtool -G enp0s31f6 rx 4096
```
- Noted errors on lab build: lro, udp, and adaptive failed.  
- Simple script
```
#!/bin/bash

for var in $@
do
  echo "Turning off offloading on $var"
  ethtool -K $var tso off gro off lro off gso off rx off tx off sg off rxvlan off txvlan off
  ethtool -N $var rx-flow-hash udp4 sdfn
  ethtool -N $var rx-flow-hash udp6 sdfn
  ethtool -C $var adaptive-rx off
  ethtool -C $var rx-usecs 1000
  ethtool -G $var rx 4096
done
```
### Suricata install
1. Install suricata with `yum install suricata`
2. Check `tcpdump -i <interface>` to make sure traffic is flowing on interface.
3. Modify the /etc/suricata/suricata.yaml to ensure functionality. Disable fast log, outputs, find default-log-dir, and rule-files
4. Run `suricata-update` to build the /var/lib/suricata/rules.
5. Set the interface for suricata to read with at `/etc/sysconfig/suricata` from the default to `--af-packet=eth1 --user suricata`
- Config overrides.yaml at this time to make changes simpler, and then tag the override.yaml at the top of the configuration files.
- When managing threads and processors, can use `sudo cat /proc/cpuinfo | egrep -e 'processor|physical id|core id' | xargs -l3`
