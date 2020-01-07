# Installation of CentOS 7
### Tools
- CentOS 7 image drive

## Notes
Hard planning
- Know how much ram, drive, etc the sensors have access to
|Resource|
|----|
|CPU|
|Disk|
|RAM|

Boot into installation drive.  
Select Install CentOS 7   
Select English  
Check date & time  
Setup management network port  
disable kdump  
Modify Drive Setup   
- Delete and Reclaim space using auto partition
- Go back in, configure manual partition then select auto Setup
- Reduce /swap, add /var, /var/log, /tmp.
- Create volumes for KAFKA, SURICATA, ElasticSearch, Stenographer, and FSF  
- Create a user, mark as admin, leave root blank

## Layout
Sensor  
- 4 CPU
- 32 ram
- 2 Disk, SSD & HHD

Programs
- Zeek : TLP
- Stenographer : Has Disk Write/Read
- SURICATA : Disk Write/Read
- KAFKA : Disk Wrie/Read
- Logstash : Memory
- ElasticSearch : Disk Read/Write
- Kibana : Memory
- FileBeat : Disk Read
- File Scanning Framework(FSF) : Disk Write/Read

#### Disk Usage
- KAFKA
- SURICATA
- ElasticSearch
- Stenographer
- FSF

#### CPU Usage
- Zeek
- SURICATA
- FSF (Dependent on how setup)
- ElasticSearch

#### RAM Usage
- Zeek
- Logstash
- ElasticSearch

## Setup
Studentgroup10  
Wifi  
Edge RTR : 192.168:2.1 <> 10.0.0.2  
SW : 10.0.0.1  
PFSense :10.0.10.1 <> 172.16.10.1  
Sensor : 172.16.10.100  
Subnet: /24  
