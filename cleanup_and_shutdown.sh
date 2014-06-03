#!/bin/bash

SELF_PID=$1
#echo "PID of myself is: $SELF_PID"

# shutdown jenkins & cleanup jobdir
/etc/init.d/jenkins stop
rm -rf /var/lib/jenkins/jobs/*

# kill bashs & cleanup bash history
for PID in $(ps aux | grep ' bash$' | awk -F ' ' '{ print $2;}');do
  if [ ! ${PID} -eq ${SELF_PID} ];then  
    #echo "kill $PID"
    kill -9 $PID
  fi
done
[ -f /home/heise/.bash_history ] && rm /home/heise/.bash_history
[ -f /home/vagrant/.bash_history ] && rm /home/vagrant/.bash_history
[ -f /root/.bash_history ] && rm /root/.bash_history

# cleanup logfiles
for F in $(ls -1 /var/log | grep '\.[0-9]\.gz$');do rm /var/log/$F;done
for F in $(ls -1 /var/log | grep '\.[0-9]$');do rm /var/log/$F;done
for F in $(ls -1 /var/log | grep '\.old$');do rm /var/log/$F;done
for F in $(find /var/log -type f -print);do echo "" > $F;done

# shutdown
shutdown -h now &
kill -9 $?

