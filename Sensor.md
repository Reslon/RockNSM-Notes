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
  , "Interface": "<interface>"
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
- If the error is stenotype issues, check the interface is correctly named  
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
6. Run chown to make /data/suricata owned by suricata.
7. Start suricata
8. Verify suricata is writing to default-dir as outlined

### Zeek Installation
Contains
```
zeek  
zeekctl  
zeek-core  
```

```
zeek-plugin-af_packet  
zeek-plugin-kafka  
```
These are packaged together in the lab, so `yum install zeek` will get the core, then install the plugins separately, but in production each may be required to be installed individually.  
1. Begin with `yum install zeek`  
2. The config file location depends on the RPM installed, `/etc/zeek` or `opt/zeek/etc`.
 - networks.cfg is used to tell zeek what the local trusted IP space using CIDR notation.
 - zeekctl.cfg tells zeek what directory to log to, and how to log/what to use. Add `lb_custom.InterfacePrefix=af_packet::` to this file.
 - node.cfg list out the nodes zeek has access to and interface they're on. If not running standalone, comment out lines 8-11 and set clustered configuration lines.
    - `pin_cpus` to pin specific cpus, `lb_method` and `lb_proc` to set load balance methods and processes, `env_vars=fanout_id=[x>50]`
3. Move to /usr/share/zeek/site and modify the local.zeek by enbling protocol logging, and adding  
```
#@load scripts/json.zeek
@load scripts/afpacket
@load scripts/kafka
```
4. Create the afpacket.zeek with the line `redef AF_Packet::fanout_id = strcmp(getenv("fanout_id"),"") == 0 ? 0 : to_count(getenv("fanout_id"));`  
5. Create the kafka.zeek with the following
```
redef Kafka::topic_name = "zeek-raw";
redef Kafka::json_timestamps = JSON::TS_ISO8601;
redef Kafka::tag_json = F;
redef Kafka::kafka_conf = table(
    ["metadata.broker.list"] = "172.16.10.100:9092");

event bro_init() &priority=-5
{
    for (stream_id in Log::active_streams)
    {
        if (|Kafka::logs_to_send| == 0 || stream_id in Kafka::logs_to_send)
        {
            local filter: Log::Filter = [
                $name = fmt("kafka-%s", stream_id),
                $writer = Log::WRITER_KAFKAWRITER,
                $config = table(["stream_id"] = fmt("%s", stream_id))
            ];

            Log::add_filter(stream_id, filter);
        }
    }
}
```

6. Create the json.zeek with the follows
```
redef LogAscii::use_json=T;
redef LogAscii::json_timestamps = JSON::TS_ISO8601;
```
7. Run zeekctl check next to verify scripts are okay and ready for deployment. Fix any errors
8. Run zeekctl deploy.

### Verify setup so far
1. Verify Stenographer, Suricata, and zeek are running
2. Check /data/<service> to verify data is being logged.
3.

### FSF
1. Pull FSF onto the sensor, via the required methods. For lab, `yum install fsf` will pull all the required dependencies.
2. Open the config.py file in /opt/fsf/fsf-server/conf and make the following changes:
 - LOG_PATH changed to the directory for Logs, Python list format
 - YARA_PATH to the rules folder at /var/lib/yara-rules/rules.yara
 - EXPORT_PATH if moving file archives to a storage location
 - Change SERVER_CONFIG socket to sensor IP.
    - `'<ip>'` is the proper format
3. Open the config.py in /opt/fsf/fsf-client/conf and make the following changes:
 - Changes SERVER_CONFIG to sensor IP
4. Create the directories outlined in server config.py if needed.
5. Use chown to make the /data/fsf/* files owned by fsf user.

### Kafka Installation
#### Zookeeper notes
- There are things called topics, which can be considered harddrives.
- One can be made for each program Kafka is talking to. These can be further partitioned down to specific machines
- Can be split up among thousands of partitions, multiple partitions can be placed on a machine.  
- Replicated drives will not be on a machine that has that drive.

1. Install zookeeper and kafka with yum
2. Modify `etc/zookeeper/zoo.cfg` if running multi node.  
3. Start zookeeper with systemctl, then enable it so it will start on reboot.
3. Install kafka
4. Modify the /etc/kafka/server.properties with the following  
```
31: Add IP of Sensor
36: Uncomment line, add IP of Sensor
60: Add in directory paths for Logs
65: If building out clustered partitions, enter the number of them.
103: Determine length of time logs are kept
107: Determine amount of data kept
123: If remote zookeeper, update this line with where the zookeeper is.
```  
5. Use chown on /data/kafka to give kafka user rights to the partition folder if not done yet.
6. Start the kafka with systemctl.
#### Kafka scripts
- `/usr/share/kafka/bin/kafka-topics.sh --list --bootstrap-server 172.16.10.100:9092` will list out the topics that kafka can see.
-

### Installing Filebeat
1. run `yum install filebeat` to pull and install the rpm for filebeat if not done already.
- Cannot mutate informtion, but can add tags to it as it processes information.
- Tagging can be controlled/modified
2. Modify filebeat.yml
```  
24: Set logs to true  
28: Set the path to the location of the logs.  
For lab, /data/suricata/eve.json, /data/fsf/logs/rockout.log  
```  

An easier and smarter way is to use prospector, as follows:  

```
filebeat.inputs:
  - type: log
    paths:
      - /data/suricata/eve.json
    json.keys_under_root: true
    fields:
      kafka_topic: suricata-raw
    fields_under_root: true
  - type: log
    paths:
      - /data/fsf/logs/rockout.log
    json.keys_under_root: true
    fields:
      kafka_topic: fsf-raw
    fields_under_root: true
processors:
  - decode_json_fields:
    fields:
      - message
      - Scan Time
      - Filename
      - objects
      - Source
      - Meta
      - Alert
      - Summary
    process_array: true
    max_depth: 10
  ```  

3. Under Outputs around line 140, comment out the elasticsearch and add a kafka section. Then add the following:  

```
output.kafka:
  hosts: ["172.16.10.100:9092"]
  topic: '%{[kafka_topic]}
  ```  

4. Start filebeat with systemctl, verify the topics appear in the kafka directory.  
5.

### Install elasticsearch
1. Run `yum install elasticsearch`
2. Open the `/etc/elasticsearch/elasticsearch.yml`  
```  
see elasticsearch.yml
```  
3. Modify ram size in jmv.yml
4. Create the elasticsearch.service.d directory in /etc/systemd/system/
5. Create override.conf in the elasticsearch.service.d directory. Places the following lines:  
```  
[Service]
LimitMEMLOCK=infinity
```

6. Set ownership of partition folders to elasticsearch.  
7. Allow elasticsearch through the firewall, default ports are 9200 and 9300 tcp.
8. Start elasticsearch with systemctl
9. curl <addr>:9200 will verify if it is running. `/_cat` added to the end will show additional options to check on elasticsearch  

### Installing Kibana
1. Install kibana with yum.
2. Modify `vi /etc/kibana/kibana.yml`
3. Set server.hosts and elasticsearch.hosts
3. Start kibana with systemctl
4. Open port 5601 in the firewall
5. Check if the webpage is available.

### Logstash
1. Install logstash rpm with yum
2. Navigate to /etc/logstash/conf.d.
##### Begin making pipelines
3. Create a file `100-input-zeek.conf`
 - lookup input pipelines on elastic site: https://www.elastic.co/guide/en/logstash/current/input-plugins.html
 - Example input start
```
input {
 kafka {
  add_field => { "[@metadata][stage]" => "zeek-raw" }
  topics => ["zeek-raw"]
  bootstrap_servers => "172.16.10.100:9092"
  # Set this to one per kafka partition to scale up
  #consumer_threads => 4
  group_id => "bro_logstash"
  codec => json
  auto_offset_reset => "earliest"
 }
}
```

4. Create the `500-filter-zeek.conf`.
5. Create the `999-output-zeek.conf`
6. Build templates
7. start logstash
8. verify indices show up

##### Building a templates
1. Make modification to templates. Save.
2. Stop Logstash
3. Delete index in Kibana
4. start logstash
5. remake index in Kibana
6. open dev tools
7. use GET to pull mapping, use PUT to place new mapping after modifcations.

##### Filter templates
1.
