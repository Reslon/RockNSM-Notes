# General
- Chown the partitions to the program users properly.

# Repo/Yum/nginx
- The yum repo file has to match exactly how the file is stored so yum can find it.
- nginx server_name is a list of short names, not the name of the server to placed in the files
- host file, add ip/domain to help make through

# Stenographer
- Crash without note may be interface issue
- Double check pwd
- ensure ownership is incorrectly
- Verify `which stenotype` pwd

# Zeek
- Doublecheck spelling and lines for proper Information
- read errors given by check, and diag
- use cleanup all when issues causes changes to files to fix issues

# Filebeat
- Ensure accuracy of spelling
 - inputs, not input
 - If previous things are inproperly programmed, will impact filebeat

# kibana
- Verify firewall is Open
- Verify host address in yml file.

# Logstash
- Checking for missing indices
 - Check in /data/zeek/log/current/ for logs being made.
 - Check `/usr/share/kafka/bin/kafka-topics.sh --list --bootstrap-server <ip>:<port>` for topics created
 - Same script, use --describe instead of list to see where a --topic is residing.
 - `/usr/share/logstash/bin/logstash -f /etc/logstash/conf.d/100-input-zeek.conf -t` can test files for validation
 -
