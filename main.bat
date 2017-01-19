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

echo working dir is: %workingdir%
echo device is: %device%
echo src path is: %srcpath%

if %device% equ edison (
  SET imagename="zhijzhao/edison"
) else (
  if %device% equ raspberrypi (
    SET imagename="zhijzhao/raspberrypi"
  ) else (
    echo unknown device
  )
)

echo imagename is: %imagename%

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

echo working dir is: %workingdir%
echo src path param is: %srcpathparam%

echo docker run -i -v %workingdir%:/source %imagename% /index.sh %task% %srcpathparam% %*
docker run -i -v %workingdir%:/source %imagename% /index.sh %task% %srcpathparam% %*
