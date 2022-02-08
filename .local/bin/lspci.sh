#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

lspci -k |egrep -A2 "VGA|3D"
