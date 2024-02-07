@echo off

rem Define paths and commands
set "steamcmd_path=C:\Users\User\SteamCMD\steamcmd.exe"
set "server_dir=C:\Users\User\SteamCMD\steamapps\common\enshrouded-server"
set "app_id=2278520"
set "server_executable=enshrouded_server.exe"
set "commands_file=%~dp0commands.txt"

rem Check if the server is running
tasklist | findstr /i "%server_executable%"
if not %errorlevel% equ 0 (
    echo Server is not running. Proceeding with the backup process.
) else (
    echo Server is running.
    echo Warning: The server is running. Please shut it down before running this script.
    pause
    exit /b
)

rem Create a temporary file containing commands for steamcmd.exe
(
    echo @ShutdownOnFailedCommand 1
    echo @NoPromptForPassword 1
    echo force_install_dir "%server_dir%"
    echo login anonymous
    echo app_update %app_id% validate
    echo quit
) > "%commands_file%"

rem Run steamcmd.exe with the commands file
echo Running steamcmd.exe...
"%steamcmd_path%" +runscript "%commands_file%"

rem Restart the server
echo.
echo Server updated. Restarting...
cd /d "%server_dir%"
echo Starting server in background...
start "" "%server_executable%"
