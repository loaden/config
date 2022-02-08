#!/bin/bash
# 维护：Yuchen Deng [Zz] QQ群：19346666、111601117

pkg="$*"

function getDepends()
{
  ret=`LANG=C apt-cache depends $1 |grep -i depends |sed 's/(.*)//' |cut -d: -f2`
  if [[ -z $ret ]]; then
    echo "$1 No depends"
    echo -n
  else
    for i in $ret
    do
      if [[ `echo $pkg |grep -e "$i "` ]]; then
        echo "$i already in set"
        echo -n
      elif [[ $i =~ '<' ]]; then
          echo "Drop $i"
      elif [[ "$i" != "libc6" &&
              "$i" != "libcairo2" &&
              !("$i" =~ "glib") &&
              !("$i" =~ "gtk") &&
              !("$i" =~ "font")
           ]]; then
#         echo "Download $i ing"
        pkg="$pkg $i"
        getDepends $i
      fi
    done
  fi
}

for j in $@
do
  getDepends $j
done

# echo $pkg
apt download $pkg -d -y
