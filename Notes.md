Preparing for deployment  

Stop all the services with  
`systemctl stop logstash suricata stenographer fsf kafka zookeeper elasticsearch`  

*elasticsearch*
- Can remove the elasticsearch partition folders to clean this to blank if needed, but this removes configuration and mapping files as well.  
*kafka*  
- First do `rm -rf /var/lib/zookeeper/version-2/`
- Second run `rm -rf /data/kafka/*`
- This will clear the messaging queue, and clears zookeeper of the cache for kafka.  
*fsf*  
- Clear this by `rm -f /data/fsf/logs/rockout.log`
*suricata*
- Clean this by `rm -f /data/suricata/eve.json`
*PCAP Data/History*  
- Run the following two commands
```
rm -f /data/stenographer/thread0/packets/*
rm -f /data/stenographer/thread0/index/*
```  

*Kibana*
- In the management of Kibana, remove all indices from the index management.

Restart the system with  
`systemctl start elasticsearch` followed by  
`systemctl start suricata stenographer zookeeper kafka logstash fsf`  
followed by `zeekctl deploy`  
