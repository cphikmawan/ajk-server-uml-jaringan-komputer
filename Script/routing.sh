#!/bin/bash
# CREATED BY CLOUD C1F, PLEASE SAVE THIS SCRIPT.
nidtuntap=72
starttun=8
last_tuntap_plus_satu=117

niddmz=73
startdmz=16

while [ 1 ]
do
echo "Running..."
counter=0
    while [ $counter -lt $last_tuntap_plus_satu ]
    do
        tun_kel=$[$starttun + $counter + 1]
        #echo "tuntap 10.151.$nidtuntap.$tun_kel"
        dmz_kel=$[$startdmz + ($counter * 2 ) ]
        #echo "dmz 10.151.$niddmz.$dmz_kel"

        # Cari tap pakek command
        in_tap=` /sbin/ip addr | /bin/grep -EB2 "10.151.$nidtuntap.$tun_kel" | /usr/bin/awk '/tap/ {print $2}' | /bin/grep tap | /usr/bin/awk '{gsub(":",""); print $1}'`
        ip_tun=` /sbin/ip addr | /bin/grep -EB2 "10.151.$nidtuntap.$tun_kel" | /usr/bin/awk '/tap/ {print $2}' | /bin/grep 10.151 | /usr/bin/awk '{gsub("/32",""); print $1}'`
        #echo "$in_tap"
        #echo "$ip_tun"

        # #if kalo ada del dulu baru tambah
        ip_tuntap="10.151.$nidtuntap.$tun_kel"
        #echo "$ip_tuntap"
        tun_gw=$[$tun_kel + 1]
        #echo "$tun_gw"
        if [ "$ip_tuntap" = "$ip_tun" ]; then
            #echo "benar"
            /sbin/route del -net 10.151."$niddmz"."$dmz_kel" netmask 255.255.255.248 gw 10.151."$nidtuntap"."$tun_gw" dev "$in_tap"
            /sbin/route add -net 10.151."$niddmz"."$dmz_kel" netmask 255.255.255.248 gw 10.151."$nidtuntap"."$tun_gw" dev "$in_tap"
            echo "script is running and restart every 10s"
        fi

        counter=$[$counter+4]
        #echo "counter $counter"
    done
    `sleep 10`
done


