@echo off
setlocal EnableExtensions EnableDelayedExpansion

REM Digital Forensics Artifacts extractor based on Robocopy
REM Logic
REM 1. Mount the disk in Read-Only Mode via Arsenal Image mounter
REM 2. Double click RoboVelocity 
REM 3. Run it through Admin Privilleges
REM 4. Target the NTFS mounted disk
REM 5. Enter the Destination Folder of extracted Data


REM Important Notes..
REM Admin Rights Needed before Running RoboVelocity
REM $J and $MFT copy not included

:thesourceloop
set /p "SOURCE=Enter the Source file directory path: "
set "SOURCE=%SOURCE:"=%"

if not exist "%SOURCE%" (
  echo Not found. Try again.
  goto :thesourceloop
)

echo.

set /p "DEST=Enter the DESTINATION file directory path: "
set "DEST=%DEST:"=%"

if not exist "%DEST%" (
  echo %DEST% was not found.
  echo "Creating.."
  mkdir "%DEST%"
  echo "%DEST%, as destination folder was created"
)
echo.
echo.
echo.


REM Destination Folders Creation

REM Amcache Directory
if not exist "%DEST%\AppCompat" mkdir "%DEST%\AppCompat"
if not exist "%DEST%\AppCompat\Programs" mkdir "%DEST%\AppCompat\Programs"

REM Registry Directory
if not exist "%DEST%\config" mkdir "%DEST%\config"

REM Windows Logs Directory
if not exist "%DEST%\logs" mkdir "%DEST%\logs"

REM Prefetch Directory
if not exist "%DEST%\Prefetch" mkdir "%DEST%\Prefetch"

REM SRUM (System Resource Usage Manager) Directory
if not exist "%DEST%\SRU" mkdir "%DEST%\SRU"

REM Users Directory
if not exist "%DEST%\Users" mkdir "%DEST%\Users"

REM Pagefile Directory
if not exist "%DEST%\Pagefile" mkdir "%DEST%\Pagefile"


REM ######################################################################################################################################################################

REM Setting Anchor Variables on Target Disk..

set "Registry=%SOURCE%\Windows\System32\config"
set "Logs=%SOURCE%\Windows\System32\winevt\Logs"
set "Prefetch=%SOURCE%\Windows\Prefetch"
set "Amcache=%SOURCE%\Windows\appcompat\Programs"
set "SRUM=%SOURCE%\Windows\System32\sru"
set "DefendQ=%SOURCE%\ProgramData\Microsoft\Windows Defender\Quarantine"
set "DefendSup=%SOURCE%\ProgramData\Microsoft\Windows Defender\Support"


REM ######################################################################################################################################################################

REM Executing Robocopy To Targets..

REM ######################################################################################################################################################################

echo      Copying Registry files..
robocopy "%Registry%" "%DEST%\config" "SYSTEM" "SYSTEM.LOG1" "SYSTEM.LOG2" "SECURITY" "SECURITY.LOG1" "SECURITY.LOG2" "SOFTWARE" "SOFTWARE.LOG1" "SOFTWARE.LOG2" "SAM" "SAM.LOG1" "SAM.LOG2" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\config..
echo.
echo      Copying Windows Log files..
robocopy "%Logs%" "%DEST%\logs" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\logs..
echo.
echo      Copying Prefetch files..
robocopy "%Prefetch%" "%DEST%\Prefetch" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\Prefetch..
echo.
echo      Copying Pagefile.sys..
robocopy "%SOURCE%" "%DEST%\Pagefile" "pagefile.sys" /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\Pagefile..
echo.
echo      Copying Amcache files..
robocopy "%Amcache%" "%DEST%\AppCompat\Programs" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\AppCompat\Programs..
echo.
echo      Copying SRUM files..
robocopy "%SRUM%" "%DEST%\SRU" /E /COPY:DAT /DCOPY:DAT /R:3 /W:5 /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\SRU..
echo.
REM Collect Microsoft Defender Quarantine (Path: SRC:\ProgramData\Microsoft\Windows Defender\Quarantine)
REM Collect Microsoft Defender Quarantine (Path: SRC:\ProgramData\Microsoft\Windows Defender\Support)
echo      Copying Defender's Quarantine files..
robocopy "%DefendQ%" "%DEST%\Quarantine" /R:3 /W:5 /COPYALL /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\Quarantine..
echo.
echo      Copying Windows Defender Support files..
robocopy "%DefendSup%" "%DEST%\Support" /R:3 /W:5 /COPYALL /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
echo      Done on %DEST%\Support..
echo.
echo.
echo.


REM AppData for Every User Copy

set "SRCUSERS=%SOURCE%\Users"
set "DSTUSERS=%DEST%\Users"

for /f "delims=" %%U in ('dir /b /ad "%SRCUSERS%" ^| findstr /v /i "Public Default All"') do (
  echo      ==== Processing user: %%U ====
  echo.



  REM ---- NTUSER hive + transaction logs for every User ----
  
  REM ---- Collecting NTUSER.DAT hive  ----
  if exist "%SRCUSERS%\%%U\NTUSER.DAT" (
    echo      Copying NTUSER files...
    robocopy "%SRCUSERS%\%%U" "%DSTUSERS%\%%U" "NTUSER.DAT" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U..
    echo.
  )

  REM ---- Collecting Transaction log for NTUSER.DAT.LOG1 ----
  if exist "%SRCUSERS%\%%U\NTUSER.DAT.LOG1" (
    echo      Copying NTUSER.DAT.LOG1 files...
    robocopy "%SRCUSERS%\%%U" "%DSTUSERS%\%%U" "NTUSER.DAT.LOG1" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U..
    echo.
  )

  REM ---- Collecting Transaction log for NTUSER.DAT.LOG2 ----
  if exist "%SRCUSERS%\%%U\NTUSER.DAT.LOG2" (
    echo      Copying NTUSER.DAT.LOG2 files...
    robocopy "%SRCUSERS%\%%U" "%DSTUSERS%\%%U" "NTUSER.DAT.LOG2" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U..
    echo.
  )

  REM ---- AutomaticDestinations ----
  if exist "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" (
    echo      Copying AutomaticDestinations files...
    robocopy "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" "%DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\AutomaticDestinations..
    echo.
  )

  REM ---- CustomDestinations ----
  if exist "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations" (
    echo      Copying CustomDestinations files...
    robocopy "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations" "%DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent\CustomDestinations..
    echo.
  )

  REM ---- Standard Recent .lnk Files ----
  if exist "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent" (
    echo      Copying Standard Recent .lnk Files...
    robocopy "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent" "%DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent" *.lnk /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Roaming\Microsoft\Windows\Recent..
    echo.
  )

  REM ---- Office\Recent Recent .lnk Files ----
  if exist "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Office\Recent" (
    echo      Copying Office\Recent Recent .lnk Files files...
    robocopy "%SRCUSERS%\%%U\AppData\Roaming\Microsoft\Office\Recent" "%DSTUSERS%\%%U\AppData\Roaming\Microsoft\Office\Recent" *.lnk /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Roaming\Microsoft\Office\Recent..
    echo.
  )


  REM ---- UsrClass.dat Files ----
  if exist "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows\UsrClass.dat" (
    echo      Copying UsrClass.dat files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows" "%DSTUSERS%\%%U\AppData\Local\Microsoft\Windows" "UsrClass.dat" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\Microsoft\Windows..
    echo.
  )

  REM ---- UsrClass.dat.LOG1 Files ----
  if exist "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG1" (
    echo      Copying UsrClass.dat.LOG1 files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows" "%DSTUSERS%\%%U\AppData\Local\Microsoft\Windows" "UsrClass.dat.LOG1" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\Microsoft\Windows..
    echo.
  )

  REM ---- UsrClass.dat.LOG2 Files ----
  if exist "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows\UsrClass.dat.LOG2" (
    echo      Copying UsrClass.dat.LOG2 files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\Microsoft\Windows" "%DSTUSERS%\%%U\AppData\Local\Microsoft\Windows" "UsrClass.dat.LOG2" /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\Microsoft\Windows..
    echo.
  )

  REM ---- ConnectedDevicesPlatform Files ----
  if exist "%SRCUSERS%\%%U\AppData\Local\ConnectedDevicesPlatform" (
    echo      Copying ConnectedDevicesPlatform files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\ConnectedDevicesPlatform" "%DSTUSERS%\%%U\AppData\Local\ConnectedDevicesPlatform" /E /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\ConnectedDevicesPlatform..
    echo.
  )

  REM ---- Google Chrome Files (User Data) ----
  if exist "%SRCUSERS%\%%U\AppData\Local\Google\Chrome\User Data" (
    echo      Copying Google Chrome Files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\Google\Chrome\User Data" "%DSTUSERS%\%%U\AppData\Local\Google\Chrome\User Data" /E /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\Google\Chrome\User Data..
    echo.
  )

  REM ---- Microsoft Edge Files (User Data) ----
  if exist "%SRCUSERS%\%%U\AppData\Local\Microsoft\Edge\User Data" (
    echo      Copying Microsoft Edge Files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\Microsoft\Edge\User Data" "%DSTUSERS%\%%U\AppData\Local\Microsoft\Edge\User Data" /E /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\Microsoft\Edge\User Data..
    echo.
  )

  REM ---- Brave Browser Files (User Data) ----
  if exist "%SRCUSERS%\%%U\AppData\Local\BraveSoftware\Brave-Browser\User Data" (
    echo      Copying Brave Browser Files...
    robocopy "%SRCUSERS%\%%U\AppData\Local\BraveSoftware\Brave-Browser\User Data" "%DSTUSERS%\%%U\AppData\Local\BraveSoftware\Brave-Browser\User Data" /E /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Local\BraveSoftware\Brave-Browser\User Data..
    echo.
  )

  REM ---- Mozilla\Firefox Files (Profiles) ----
  if exist "%SRCUSERS%\%%U\AppData\Roaming\Mozilla\Firefox\Profiles" (
    echo      Copying Brave Browser Files...
    robocopy "%SRCUSERS%\%%U\AppData\Roaming\Mozilla\Firefox\Profiles" "%DSTUSERS%\%%U\AppData\Roaming\Mozilla\Firefox\Profiles" /E /R:3 /W:5 /COPY:DAT /DCOPY:DAT /LOG+:"%DEST%\RoboVelocity.log" >NUL 2>&1
	echo      Done on %DSTUSERS%\%%U\AppData\Roaming\Mozilla\Firefox\Profiles..
    echo.
  )
)
echo.
echo.
echo.
echo      +-----------------------------------------------------------------------------+
echo      +                                                                             +
echo      +                                                                             +
echo      + Copy completed. All files were copied to the following Destination:         +
echo      +                                                                             +
echo      +                                                                             +
echo      + %DEST%                                                                      
echo      +                                                                             +
echo      +-----------------------------------------------------------------------------+
echo      +                                                                             +
echo      + Robovelocity.log on:                                                        +
echo      +                                                                             +
echo      + %DEST%\RoboVelocity.log
echo      +                                                                             +
echo      +                                                                             +
echo      +-----------------------------------------------------------------------------+
echo.
echo.
echo.
pause
endlocal
