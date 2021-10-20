#!/bin/sh

printf '%s\n' '#!/bin/bash' 'route add -net 10.120.0.0/16 gw 192.168.16.254' 'exit 0' | sudo tee -a /etc/rc.local
sudo chmod +x /etc/rc.local

echo """[Unit]
 Description=/etc/rc.local Compatibility
 ConditionPathExists=/etc/rc.local

[Service]
 Type=forking
 ExecStart=/etc/rc.local start
 TimeoutSec=0
 StandardOutput=tty
 RemainAfterExit=yes
 SysVStartPriority=99

[Install]
 WantedBy=multi-user.target""" > /etc/systemd/system/rc-local.service


 sudo systemctl enable rc-local
