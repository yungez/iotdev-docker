@echo off
setlocal

if "%1" equ "build" (
  SET task=build
) else (
  if "%1" equ "deploy" (
    SET task=deploy
  ) else (
    echo unknown task
  )
)

echo task is: %task%
SHIFT

:arg-loop
if "%1" equ "" goto arg-done
if "%1" equ "--workingdir" goto arg-workingdir
if "%1" equ "--device" goto arg-device
SHIFT
GOTO :arg-loop

:arg-workingdir
SHIFT
SET workingdir=%1
GOTO :arg-continue

:arg-device
SHIFT
SET device=%1
GOTO :arg-continue

:arg-continue
SHIFT
goto :arg-loop

:arg-done

echo working dir is: %workingdir%
echo device is: %device%

if %device% equ edison (
  SET imagename="yungez/docker-edison"
) else (
  echo %device%
  if %device% equ raspberrypi (
    SET imagename="yungez/docker-raspberrypi"
  ) else (
    echo unknown device
  )
)

echo imagename is: %imagename%

docker pull %imagename%
docker run -i -v %workingdir%:/source %imagename% /index.sh %task% %*