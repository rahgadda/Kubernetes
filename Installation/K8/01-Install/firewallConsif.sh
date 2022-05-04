#!/bin/bash

# -- Disabling firewalld
systemctl disable firewalld
# -- Enabling iptables
yum install iptables-services -y
systemctl start iptables
systemctl enable iptables
# -- Flushing iptables
iptables -F
# -- Allowing everthing
iptables -A FORWARD -j ACCEPT
iptables -A INPUT -j ACCEPT
iptables -A OUTPUT -j ACCEPT
# -- Saving
service iptables save
systemctl restart iptables
# -- Display Settings
iptables -L -n