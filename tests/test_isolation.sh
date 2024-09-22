#!/bin/sh

sh disks.sh

## mount namespace
#echo "Mount namespace:"
#ls /proc
#
#echo "\n\n"
## network namespace
#echo "Network namespace:"
#ip -a
#
#echo "\n\n"
## ipc
#echo "IPC namespace:"
#ipcmk -M 1000K
#ipcs
#
#echo "\n\n"
#echo "PID namespace:"
## pid
#ps