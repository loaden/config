#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

WORK_DIR=$PWD
cd $2
sudo tar -I "zstd -T0" --exclude=proc --exclude=sys --exclude=dev --exclude=boot/efi --exclude=run --exclude=media --exclude=mnt --exclude=home --exclude=lost+found --one-file-system -capvf $WORK_DIR/$1.tar.zst --directory=$2 *
cd $WORK_DIR
