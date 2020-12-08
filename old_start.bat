@echo off
:python
cls
echo.
echo Is your python version is atleast v3.5 ?
echo.

set /p q=Y or N : 
IF '%q%' == 'Y' (GOTO start)
IF '%q%' == 'y' (GOTO start)
echo Exiting...Please install atleast Python v3.5 and then proceed.
EXIT /B

:start
echo.
echo Select menu
echo ================
echo 1. Delete all .pyc and .log file to clean
echo 2. Create a virtualenv and Run pip Installation and Run the Application
echo.
 
set /p x=Please provide a valid choice only:
IF '%x%' == '1' GOTO NUM_1
IF '%x%' == '2' GOTO NUM_2
GOTO start

:NUM_1
echo Deleteing all .pyc and .log file
rmdir migrations /q /s
del "*.pyc" /q /s /f
del "*.log" /q /s /f

pause
GOTO start

:NUM_2
python -m pip install --upgrade pip
pip install virtualenv
virtualenv myenv
.\myenv\Scripts\activate && pip install -r requirements.txt && python manage.py db init && python manage.py db migrate && python manage.py db upgrade && python manage.py run && pause

