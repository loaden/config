alias ll='ls -lht --color'
alias lt='ls --human-readable --size -1 -S --classify'
alias gbk2utf8='convmv -f GBK -t UTF-8 --notest --nosmart *'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias mnt="mount | awk -F' ' '{ printf \"%s\t%s\n\",\$1,\$3; }' | column -t | egrep ^/dev/ | sort"
alias gh='history|grep'
alias count='find . -type f | wc -l'
alias cpv='rsync -ah --info=progress2'

