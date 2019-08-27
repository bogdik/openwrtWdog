#/bin/sh
touch /tmp/adblock
WSCANFACE='wlan0'
SSID='SmartBOX-63'
ifconfig $WSCANFACE up
BEEINET=0
WLAN=0
WIFICHECK=3
WIFICHECKNOW=0
PINGCHECK=300
PINGCHECKNOW=0
while true
#ADBLOCK=$(wc /tmp/adblock | awk '{print $1}');
if [ "$(cat /etc/config/wireless | grep "disabled '0'")" == '' ] && [ "$(cat /etc/config/wireless | grep "disabled '1'")" == '' ]; then
        echo "        option disabled '1'">>/etc/config/wireless
fi

do
  WIFACE=$(iw dev $WSCANFACE scan | grep "SSID: $SSID");
  LFACE=$(ip a | grep SOSEDI);
  WUPFACE=$(ip a | grep 192.168.1);
  CONFIG=$(cat /etc/config/wireless | grep "disabled '0'");
  if [ "$WIFACE" != '' ] && [ "$LFACE" != '' ]; then
                echo 'Wifi UP inet can be off'
                ifdown SOSEDI
                sed -i -e "s/disabled '1'/disabled '0'/" /etc/config/wireless
                /etc/init.d/network restart
                sleep 10
                WLAN=1
                WIFICHECKNOW=0
  fi
  if [ "$WIFACE" == '' ] && [ "$LFACE" == '' ]; then
        if [ "$CONFIG" != '' ]; then
                        if [ "$WIFICHECKNOW" -ge "$WIFICHECK" ]; then
                                echo 'wifi off inet can be on'
                                sed -i -e "s/disabled '0'/disabled '1'/" /etc/config/wireless
                                /etc/init.d/network restart
                                sleep 10
                                ifup SOSEDI
                                WLAN=0
                                WIFICHECKNOW=0
                        else
                                WIFICHECKNOW=$((WIFICHECKNOW+1))
                                echo 'check now $WIFICHECKNOW'
                        fi
        else
                ifup SOSEDI
                WIFICHECKNOW=0
        fi

  fi
  if [ "$WIFACE" != '' ]; then
        WIFICHECKNOW=0
  fi
  #if [ "$WIFACE" != '' ] && [ "$LFACE" == '' ] && [ "$WUPFACE" == '' ] && [ "$CONFIG" != '' ]; then
        #       echo 'just network restart'
        #       /etc/init.d/network restart
        #       sleep 10
        #       WLAN=1
  #fi
  if [ "$WIFACE" != '' ] && [ "$LFACE" == '' ] && [ "$WUPFACE" == '' ] && [ "$CONFIG" == '' ]; then
                echo 'wifi can be off and network restat'
                sed -i -e "s/disabled '1'/disabled '0'/" /etc/config/wireless
                /etc/init.d/network restart
                sleep 10
                WLAN=1
                WIFICHECKNOW=0
  fi
#PPING=$(ping -c 3 -W 1 8.8.8.8 | grep from | wc -l | tail -n1)
#if [ $PPING -eq 0 ]; then
#       PINGCHECKNOW=$((PINGCHECKNOW+1))
#else
#       PINGCHECKNOW=0
#       echo 'ping normal'
#fi
#if [ "$PINGCHECKNOW" -ge "$PINGCHECK" ]; then
#       reboot
#fi
sleep 3
#if [ "$ADBLOCK" -lt '2' ]; then
#        /etc/adblock.sh
#fi
echo 'step'
done
