@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

REM If your zdoom.ini file is in a location other than the default, put the path to your ZDoom .ini file here:
SET ZDoomINI="..\zdoom-%username%.ini"

REM This defines the IWAD to use if a PWAD is loaded
SET IWAD="..\doom2.wad"

REM Defines the default executable to use
SET EXE=..\zdoom.exe
SET FILES=.\Wolf3D.pk7

REM SoD Only - Change this to 'Yes' to run Powershell instead of just the command prompt.
REM This more accurately emulates the original launcher .exe but can increase load time if Powershell isn't yet loaded
SET UsePS=No

REM If a command line parameter of 'GZDOOM' was provided, change the executable to GZDoom
REM If another command line parameter was provided, automatically load the IWAD as defined above
SET /A ArgCount=0    

SET Addons=""
REM Automatically load the High-Res pack if it's there
IF EXIST Wolf3D_HighRes.pk7 SET Addons=%Addons% Wolf3D_HighRes.pk7

IF /I %ArgCount% GTR 0 SET Addons=%IWAD% +set g_defaultceilings 1

REM Change to the Wolf3D TC directory so that you can drag and drop from other folders and the relative paths will still work
CD "%~dp0"

ECHO 	START %EXE% %FILES% -config "zdoom-%username%-Wolf3d.ini" -file %Addons% %*
PAUSE

REM Check to see if Wolf3D .ini file is already there
IF EXIST "zdoom-%username%-Wolf3D.ini" (
	REM If so, run normally
	START %EXE% %FILES% -config "zdoom-%username%-Wolf3d.ini" -file %Addons% %*
) ELSE (
	REM If not, do initial setup for first run
	COPY %ZDoomINI% "zdoom-%username%-Wolf3D.ini"
	START %EXE% %FILES% -config "zdoom-%username%-Wolf3d.ini" +exec Wolf3D.cfg -file %Addons% %*
)