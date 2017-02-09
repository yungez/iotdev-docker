@echo off
setlocal
echo -------------------------------------------------------

if "%1" equ "build" (
  SET task=build
) else (
  if "%1" equ "deploy" (
    SET task=deploy
  ) else (
    echo Unknown task
  )
)

echo Task: %task%
SHIFT

:arg-loop
if "%1" equ "" goto arg-done
if "%1" equ "--workingdir" goto arg-workingdir
if "%1" equ "--device" goto arg-device
if "%1" equ "--srcpath" goto arg-srcpath
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

:arg-srcpath
SHIFT
SET srcpath=%1
GOTO :arg-continue

:arg-continue
SHIFT
goto :arg-loop

:arg-done

echo Device: %device%
if defined srcpath echo Source path: %srcpath%

if %device% equ edison (
  SET imagename=zhijzhao/edison
) else (
  if %device% equ raspberrypi (
    SET imagename=zhijzhao/raspberrypi
  ) else (
    echo unknown device
  )
)

echo Image name: %imagename%

SET srcpathparam=
if %task% equ deploy (
  if exist %srcpath%\* (
    SET workingdir=%srcpath%
    SET srcpathparam=--srcdockerpath /source/*
  ) else (
    SET workingdir=%srcpath%\..
    for %%F in ("%srcpath%") do (
      SET srcpathparam=--srcdockerpath /source/%%~nxF
    )
  )
)

echo Working directory: %workingdir%
if defined srcpathparam echo Source path param: %srcpathparam%

echo -------------------------------------------------------
echo Pulling docker image...
docker pull %imagename%

echo -------------------------------------------------------
if %task% equ deploy (
  echo Deploying to device via docker container...
) else (
  echo Building code inside docker container...
)
docker run -i -v %workingdir%:/source %imagename% /index.sh %task% %srcpathparam% %*
