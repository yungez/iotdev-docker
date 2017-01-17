#!/bin/bash

save_deviceip=0
save_username=0
save_password=0
save_srcfile=0
save_srcdir=0
save_destdir=0

for arg in "$@"
do   
    if [ $save_deviceip == 1 ]
    then
        deviceip="$arg"
        save_deviceip=0
    elif [ $save_username == 1 ]
    then
        username="$arg"
        save_username=0
    elif [ $save_password == 1 ]
    then
        password="$arg"
        save_password=0
    elif [ $save_srcfile == 1 ]
    then
        srcfile="$arg"
        save_srcfile=0
    elif [ $save_srcdir == 1 ]
    then
        srcdir="$arg"
        save_srcdir=0
    elif [ $save_destdir == 1 ]
    then
        destdir="$arg"
        save_destdir=0
    else
        case "$arg" in
            "--deviceip" ) save_deviceip=1;;
            "--username" ) save_username=1;;
            "--password" ) save_password=1;;
            "--srcfile" ) save_srcfile=1;;
            "--srcdir" ) save_srcdir=1;;
            "--destdir" ) save_destdir=1;;
        esac
    fi
done

if [ -z "$srcfile" ];
then
    sshpass -p $password scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r $srcdir $username@$deviceip:$destdir
    sshpass -p $password scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -r $srcdir $username@$deviceip:$destdir
else
    sshpass -p $password scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $srcfile $username@$deviceip:$destdir
    sshpass -p $password scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $srcfile $username@$deviceip:$destdir
fi