#!/bin/bash
# 维护：Yuchen Deng [loaden] 钉钉群：35948877
# QQ群：19346666、111601117

for file in `find . -type f -a -name '*.mp4'`
do
  buf=$buf"file '${file:2}'\n"
done

echo -e $buf |sed "/^$/d" |sort -t "-" -k 2n > in.txt
ffmpeg -f concat -i in.txt -c copy out.mp4
