#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

for i in `sudo btrfs subvolume list -p / |grep .snapshots |awk '{print $ 11}'`; do sudo btrfs sub del /$i; done
sudo rm -rf /.snapshots/*

