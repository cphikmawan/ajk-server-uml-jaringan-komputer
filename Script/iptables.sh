#!/bin/bash

/sbin/iptables -I INPUT -p tcp --dport 22 -s 10.151.0.0/16 -j ACCEPT -m comment --comment "SUWUN WES GARAP NANG TC"
/sbin/iptables -I INPUT -p tcp --dport 22 -s 10.199.0.0/16 -j REJECT -m comment --comment "COK GARAPEN NANG TC"
/sbin/iptables -I INPUT -p udp --dport 22 -s 10.199.0.0/16 -j REJECT -m comment --comment "COK GARAPEN NANG TC"
/sbin/iptables -A INPUT -p tcp --dport 22 -j REJECT -m comment --comment "COK GARAPEN NANG TC"
/sbin/iptables -A INPUT -p udp --dport 22 -j REJECT -m comment --comment "COK GARAPEN NANG TC"
