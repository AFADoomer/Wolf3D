@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

REM If your zdoom.ini file is in a location other than the default, put the path to your ZDoom .ini file here:
SET ZDoomINI="..\zdoom-%username%.ini"

REM This defines the IWAD to use if a PWAD is loaded
SET IWAD="..\doom2.wad"

REM Defines the default executable to use
SET EXE=..\zdoom.exe

REM Change this to 'Yes' to run Powershell instead of just the command prompt.
REM This more accurately emulates the original launcher .exe but can increase load time if Powershell isn't yet loaded
SET UsePS=No

CLS

If '%UsePS%' NEQ 'Yes' GOTO :Standard

REM Check Windows Version
FOR /f "tokens=4 delims=[.] " %%a IN ('ver') DO (SET WinVer=%%a)

IF %WinVer% LSS 6 GOTO :Standard

:PowerShellScript
	REM Run a PowerShell script for more accurate color emulation if Vista or higher...
	 >"Wolf3D SoD.ps1" ECHO $Host.UI.RawUI.BackgroundColor = "DarkBlue"
	>>"Wolf3D SoD.ps1" ECHO $Host.UI.RawUI.ForegroundColor = "Cyan"
	>>"Wolf3D SoD.ps1" ECHO Clear-Host
	>>"Wolf3D SoD.ps1" ECHO $c = [char]0x2592
	>>"Wolf3D SoD.ps1" ECHO $margin = ' ' * 16
	>>"Wolf3D SoD.ps1" ECHO $bar = $margin + $c.ToString^(^) * 48
	>>"Wolf3D SoD.ps1" ECHO $gap = $margin + $c + ' ' * 46 + $c
	>>"Wolf3D SoD.ps1" ECHO $lead = $margin + $c + ' ' * 4
	>>"Wolf3D SoD.ps1" ECHO $tail = "$c"
	>>"Wolf3D SoD.ps1" ECHO Write-Host "`n`n`n"
	>>"Wolf3D SoD.ps1" ECHO Write-Host $bar
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $lead -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host -ForegroundColor White "1 - Spear of Destiny `(original mission`)   " -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host $tail
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $lead -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host -ForegroundColor White "2 - Mission 2: Return to Danger           " -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host $tail
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $lead -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host -ForegroundColor White "3 - Mission 3: Ultimate Challenge         " -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host $tail
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $lead -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host -ForegroundColor White "0 - Exit to DOS                           "  -NoNewline
	>>"Wolf3D SoD.ps1" ECHO Write-Host $tail
	>>"Wolf3D SoD.ps1" ECHO Write-Host $gap
	>>"Wolf3D SoD.ps1" ECHO Write-Host $bar
	>>"Wolf3D SoD.ps1" ECHO Write-Host "`n`n`n`n`n"
	POWERSHELL -File "Wolf3D SoD.ps1"
	DEL "Wolf3D SoD.ps1" /Q
GOTO :SelectionPrompt

:Standard
	REM Otherwise just run the .bat with the colors wrong.
	COLOR 1B
	ECHO.
	ECHO.
	ECHO.
	ECHO                 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ECHO                 ±                                              ±
	ECHO                 ±                                              ±
	ECHO                 ±    1 - Spear of Destiny ^(original mission^)   ±
	ECHO                 ±                                              ±
	ECHO                 ±    2 - Mission 2: Return to Danger           ±
	ECHO                 ±                                              ±
	ECHO                 ±    3 - Mission 3: Ultimate Challenge         ±
	ECHO                 ±                                              ±
	ECHO                 ±                                              ±
	ECHO                 ±                                              ±
	ECHO                 ±    0 - Exit to DOS                           ±
	ECHO                 ±                                              ±
	ECHO                 ±                                              ±
	ECHO                 ±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ECHO.
	ECHO.
	ECHO.
	ECHO.
	ECHO.

:SelectionPrompt
	CHOICE /C 1230 /N

	SET FILES=

	IF ERRORLEVEL 1 SET Files=.\SoD.pk7
	IF ERRORLEVEL 2 SET Files=.\SoD_RTD.pk7
	IF ERRORLEVEL 3 SET Files=.\SoD_TUC.pk7
	IF ERRORLEVEL 4 EXIT

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

REM Check to see if SoD .ini file is already there
IF EXIST "zdoom-%username%-SoD.ini" (
	REM If so, run normally
	START %EXE% %Files% -config "zdoom-%username%-SoD.ini" -file %Addons% %*
) ELSE (
	REM Check to see if Wolf3D .ini file is already there and copy it
	IF EXIST "zdoom-%username%-Wolf3D.ini" (
		COPY "zdoom-%username%-Wolf3D.ini" "zdoom-%username%-SoD.ini"
	REM If not, do initial setup for first run
	) ELSE (
		COPY %ZDoomINI% "zdoom-%username%-SoD.ini"
	)
	START %EXE% %Files% -config "zdoom-%username%-SoD.ini" +exec Wolf3D.cfg -file %Addons% %*
)