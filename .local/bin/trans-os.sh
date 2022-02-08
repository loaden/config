#!/bin/bash
mv bin boot dev etc lib lib32 lib64 libx32 media mnt opt proc root run sbin srv sys tmp usr var -t vmlinuz* $1
mkdir $1/swap
