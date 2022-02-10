#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo bash -c 'echo -e "[Service]\nType=simple\nExecStart=/bin/bash -c \"sleep 5s && while true; do ntpdate-debian; sleep 300; done\"\n[Install]\nWantedBy=multi-user.target" > /lib/systemd/system/ntpdate-loop.service'
cat /lib/systemd/system/ntpdate-loop.service
sudo systemctl enable ntpdate-loop.service
sudo touch -d "2020-09-12 22:12:51" /lib/systemd/system/ntpdate-loop.service
sudo systemctl start ntpdate-loop.service
sudo systemctl status ntpdate-loop.service
