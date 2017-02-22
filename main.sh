#!/bin/bash
echo -------------------------------------------------------

if [ "$1" == "build" ]
then
  task=build
elif [ "$1" == "deploy" ]
then
  task=deploy
else
  echo unknown task
fi

echo Task: $task

save_device=0
save_workingdir=0
save_srcpath=0

for arg in "$@"
do   
    if [ $save_device == 1 ]
    then
        save_device=0
        device="$arg"
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

echo Device: $device
if [ ! -z ${srcpath+x} ]
then
  echo Source path: $srcpath
fi

if [ $device == "edison" ]
then
  imagename="zhijzhao/edison"
elif [ $device == "raspberrypi" ]
then
  imagename="zhijzhao/raspberrypi"
else
  echo unknow device name
fi

echo Image name: $imagename

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

echo Working directory: $workingdir

echo -------------------------------------------------------
echo Pulling docker image...
docker pull $imagename

echo -------------------------------------------------------
if [ $task == "deploy" ]
then
  echo Deploying to device via docker container...
else
  echo Building code inside docker container...
fi

docker run --rm -i -v $workingdir:/source $imagename /index.sh $task $srcpathparam $@