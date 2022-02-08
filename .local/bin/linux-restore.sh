#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

sudo tar -xpvf $1 --directory=$2
WORK_DIR=$PWD
cd $2
[ -d usr ] && sudo mkdir -p proc sys dev boot/efi run media mnt home
cd $WORK_DIR

