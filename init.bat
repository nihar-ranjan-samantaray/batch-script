@echo off
REM Runs on Windows
 
:start
cls
echo.
echo.
echo Select menu
echo ================
echo 1. Delete all .pyc and .log file to clean
echo 2. Create a virtualenv and Run pip Installation
echo 3. db init
echo 4. db migrate
echo 5. db upgrade
echo 6. test
echo 7. run
echo.
 
REM set the python version here
set python_ver=37
 
set /p x=Pick:
IF '%x%' == '1' GOTO NUM_1
IF '%x%' == '2' GOTO NUM_2
IF '%x%' == '3' GOTO NUM_3
IF '%x%' == '4' GOTO NUM_4
IF '%x%' == '5' GOTO NUM_5
IF '%x%' == '6' GOTO NUM_6
IF '%x%' == '7' GOTO NUM_7
GOTO start

:NUM_1
echo Deleteing all .pyc and .log file
del "*.pyc" /s /f /q
del "*.log" /s /f /q
del "migrations" /s /f /q
pause
GOTO start

:NUM_2
pip install virtualenv
virtualenv myenv
.\myenv\Scripts\activate && pip install -r requirements.txt && pause && GOTO start

:NUM_3
python manage.py db init
pause
GOTO start

:NUM_4
python manage.py db migrate
pause
GOTO start

:NUM_5
python manage.py db upgrade
pause
GOTO start

:NUM_6
python manage.py test
pause
GOTO start

:NUM_7
python manage.py run
