@echo off
:start
echo.
call pm2 list
echo.
echo 1: Stop Eidola Public API
echo 2: Stop Eidola Public Portal
echo 3: Stop Both
echo 4: Deactivate and Exit
echo.

set /p x=Choose what you want : 
IF '%x%' == '1' GOTO NUM_1
IF '%x%' == '2' GOTO NUM_2
IF '%x%' == '3' GOTO NUM_3
IF '%x%' == '4' GOTO NUM_4

:NUM_1
echo "Stopping Eidola Public API"
call pm2 delete eidolapublicapi
GOTO start

:NUM_2
echo "Stopping Eidola Public Portal"
call pm2 delete eidolapublicportal
GOTO start

:NUM_3
echo "Stopping Both Eidola Public API and Portal"
call pm2 delete eidolapublicapi
call pm2 delete eidolapublicportal
GOTO start

:NUM_4
call deactivate
call cmd
