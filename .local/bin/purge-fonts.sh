#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

sudo apt purge fonts-noto-cjk* -y
sudo apt purge fonts-noto-*
sudo apt purge fonts-arphic-* -y
sudo apt purge fonts-opendyslexic -y
sudo apt purge fonts-deva* -y
sudo apt purge fonts-mlym* -y
sudo apt purge fonts-telu* -y
sudo apt purge fonts-liberation* -y
sudo apt purge fonts-lohit* -y
sudo apt purge fonts-tlwg* -y
sudo apt purge fonts-sil* -y
sudo apt purge fonts-kacst* -y
sudo apt purge -y fonts-khmeros-core
sudo apt purge -y fonts-lklug-sinhala
sudo apt purge -y fonts-tibetan-machine
sudo apt purge -y fonts-pagul
sudo apt purge -y fonts-lao

sudo apt install fonts-wqy-microhei -y
sudo apt autopurge -y

