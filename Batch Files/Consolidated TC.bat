@ECHO OFF

REM If your zdoom.ini file is in a location other than the default, put the path to your ZDoom .ini file here:
SET ZDoomINI="..\zdoom-%username%.ini"

REM This defines the IWAD to use if a PWAD is loaded
SET IWAD="..\doom2.wad"

REM Defines the default executable to use
SET EXE=..\zdoom.exe

REM If a command line parameter was provided, automatically load the IWAD as defined above
REM If a command line parameter of 'GZDOOM' was provided, change the executable to GZDoom
REM If another command line parameter was provided, automatically load the IWAD as defined above
SET /A ArgCount=0    
FOR %%C IN (%*) DO (
	IF /I "%%C" EQU "GZDOOM" (
		SET EXE=%EXE:zdoom=gzdoom%
	) ELSE (
		SET /A ArgCount+=1
	)
)

SET Addons=""
IF /I %ArgCount% GTR 0 SET Addons=%IWAD%

REM Change to the Wolf3D TC directory so that you can drag and drop from other folders and it will still work
CD "%~dp0"

IF EXIST Wolf3D_HighRes.pk7 SET Addons=%Addons% Wolf3D_HighRes.pk7

REM Check to see if Wolf3D .ini file is already there
IF EXIST "zdoom-%username%-SoD.ini" (
	REM If so, run normally
	START %EXE% .\Wolf3D_Common.pk7 -config "zdoom-%username%-SoD.ini" -file %Addons% %*
) ELSE (
	REM If not, do initial setup for first run
	COPY %ZDoomINI% "zdoom-%username%-SoD.ini"
	START %EXE% .\Wolf3D_Common.pk7 -config "zdoom-%username%-SoD.ini" +exec Wolf3D.cfg -file %Addons% %*
)