# Spanning and Tapping  
How to duplicate traffic? 2 ways.  
1. a switch SPAN Port  
2. Dedicated tap  
#### Switch Span
A switch is a layer 2 device that uses MAC addresses to direct packets, but there are also layer 3 switches referred to as SMART / MANAGED switches. These provide additional features such as VLANs, QoS, and Span ports. A span port copies traffic and sends it out that port. Unlike a tap, this will show everything that happens, assuming information is not loss to load.  
#### Dedicate Tap
A tap is piece of network hardware that duplicates all the traveling packets to a physical port dedicated to copying traffic.  
#### LAB - Using a Tap
Now lets get things reconnected using a dedicated tap. The Dualcomm device provided is powered by usb cable.  
Validate that the data feed is on the listening interface with  
`sudo tcpdump -i enp2s0`
