#!/bin/bash

save_device=0
save_workingdir=0
save_srcpath=0

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
          imagename="zhijzhao/edison"
        elif [ $arg == "raspberrypi" ]
        then
          imagename="zhijzhao/raspberrypi"
        else
          echo unknow device name
        fi
    elif [ $save_workingdir == 1 ]
    then
        workingdir="$arg"
        save_workingdir=0
    elif [ $save_srcpath == 1 ]
    then
        srcpath="$arg"
        save_srcpath=0
    else
        case "$arg" in
            "--device" ) save_device=1;;
            "--workingdir" ) save_workingdir=1;;
            "--srcpath" ) save_srcpath=1;;
        esac
    fi
done

if [ $task == "deploy" ]
then
  if [[ -d $srcpath ]]; then
    workingdir=$srcpath
    srcpathparam="--srcdockerpath /source/*"
  elif [[ -f $srcpath ]]; then
    workingdir=$srcpath/..
    srcpathparam="--srcdockerpath /source/$(basename $srcpath)"
  else
    echo "$srcpath is not valid"
    exit 1
  fi
fi

echo working dir is: $workingdir
echo src path param is: $srcpathparam

echo docker pull $imagename
docker pull $imagename

echo docker run -i -v $workingdir:/source $imagename /index.sh $task $srcpathparam $@
docker run -i -v $workingdir:/source $imagename /index.sh $task $srcpathparam $@