wget http://winhelp2002.mvps.org/hosts.txt -O /tmp/adblock0
wget http://hosts-file.net/ad_servers.txt -O /tmp/adblock1
#wget https://adaway.org/hosts.txt -O /tmp/adblock2
wget "http://pgl.yoyo.org/adservers/serverlist.php?hostformat=hosts&showintro=0&mimetype=plaintext" -O /tmp/adblock3
sed 's/^\(.*\).$/\1/' /tmp/adblock0 > /tmp/adblock
sed 's/^\(.*\).$/\1/' /tmp/adblock1 >> /tmp/adblock
#sed 's/^\(.*\).$/\1/' /tmp/adblock2 >> /tmp/adblock
sed 's/^\(.*\).$/\1/' /tmp/adblock3 >> /tmp/adblock
rm -f /tmp/adblock0
rm -f /tmp/adblock1
rm -f /tmp/adblock2
rm -f /tmp/adblock3
/etc/init.d/dnsmasq restart
