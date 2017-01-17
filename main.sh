#!/bin/bash

save_device=0
save_workingdir=0

if [ "$1" == "build" ]
then
  task=build
elif [ "$1" == "deploy" ]
then
  task=deploy
else
  echo unknown task
fi

for arg in "$@"
do   
    if [ $save_device == 1 ]
    then
        save_device=0
        if [ $arg == "edison" ]
        then
          imagename="edison"
        elif [ $arg == "raspberrypi" ]
        then
          imagename="yungez/docker-raspberrypi"
        else
          echo unknow device name
        fi
    elif [ $save_workingdir == 1 ]
    then
        workingdir="$arg"
        save_workingdir=0
    else
        case "$arg" in
            "--device" ) save_device=1;;
            "--workingdir" ) save_workingdir=1;;
        esac
    fi
done

#docker pull yungez/docker-edison
docker run -i -v $workingdir:/source $imagename /index.sh $task $@