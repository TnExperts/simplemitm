# simplemitm
A set of configuration files to set up a rogue wireless access point, forward traffic through another wifi connection, and sniff/inject HTTP traffic in the middle.

Required hardware: two wireless network adapters, assigned to wlan0 (connected to the internet) and wlan1 (not connected)

Required packages: macchanger, hostapd, isc-dhcp-server, mitmproxy

No installation is necessary beyond the packages listed above. Just download the three files, make sure simplemitm.sh is executable, and run it. Feel free to change the SSID of your rogue access point in simplemitm-dhcpd.conf.
```
sudo apt-get install git macchanger hostapd isc-dhcp-server mitmproxy
git clone https://github.com/braindead-sec/simplemitm
cd simplemitm
chmod +x simplemitm.sh
./simplemitm.sh
```

Running this script will start up a wireless access point named "linksys" that hands out DHCP addresses in the 10.1.1.0/24 subnet. It forwards all traffic from that network to wlan0 via bridge interface br0, then redirects traffic on port 80 to port 8080 and launches mitmproxy to listen on that port. From there, you can use mitmproxy to sniff HTTP conversations and manipulate the traffic.

For further reading, see http://docs.mitmproxy.org/en/latest/mitmproxy.html
