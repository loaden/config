#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

# 刷新字体缓存
fc-cache -rv

# 检查字体匹配
fc-match Monospace
fc-match Sans
fc-match Serif
FC_DEBUG=1024 fc-match | grep Loading
fc-conflist | grep +
fc-match --verbose sans-serif | grep -v 00
# FC_DEBUG=4 fc-match Monospace | grep -v 00 > log
echo
echo fc-match --sort 'Serif:lang=zh-cn' ......
fc-match --sort 'Serif:lang=zh-cn'
echo
echo fc-match --sort 'Monospace:lang=zh-cn' ......
fc-match --sort 'Monospace:lang=zh-cn'
echo
echo fc-match --sort ......
fc-match --sort
