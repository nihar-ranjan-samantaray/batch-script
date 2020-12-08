@echo off
python --version
echo %ERRORLEVEL%
if %ERRORLEVEL% == 0 (echo Python 3 is already installed in your System & GOTO nodecheck)
echo Python 3 is not installed in your system
GOTO pythondownload

:pythondownload
echo.
IF NOT EXIST C:\EidolaInstall mkdir C:\EidolaInstall
echo Downloading Python 3.7.4
echo.
powershell -Command "Invoke-WebRequest https://www.python.org/ftp/python/3.7.4/python-3.7.4-amd64.exe -OutFile C:\EidolaInstall\python-3.7.4.exe"
pause
GOTO pythoninstall

:pythoninstall
echo Installing Python 3.7.4
powershell -Command "C:\EidolaInstall\python-3.7.4.exe InstallAllUsers=1 PrependPath=1 Include_test=0 TargetDir=C:\EidolaInstall\Python374"
IF NOT EXIST C:\Program-Files mklink /J C:\Program-Files "C:\Program Files"
SET PATH=C:\EidolaInstall\Python374;%PATH%  
echo Please finish the Python installation and then
pause

echo -------------------Successfully installed python-------------------------
GOTO nodecheck

:nodecheck
node -v
echo %ERRORLEVEL%
IF %ERRORLEVEL% == 0 (echo Node is already installed in your System & GOTO gitcheck)
GOTO nodedownload

:nodedownload
echo.
IF NOT EXIST C:\EidolaInstall mkdir C:\EidolaInstall
echo Node is not installed on your system
echo Downloading Node
powershell -Command "Invoke-WebRequest  https://nodejs.org/dist/v12.18.2/node-v12.18.2-x64.msi -OutFile C:\EidolaInstall\node.msi"
REM call npm install --global --production windows-build-tools
pause
GOTO nodeinstall

:nodeinstall
echo Installing Node,npm
powershell -Command "C:\EidolaInstall\node.msi InstallAllUsers=1 PrependPath=1 Include_test=0"
echo Please finish the Node installation and then
pause
echo -------------------Successfully installed node-------------------------

IF NOT EXIST C:\Program-Files mklink /J C:\Program-Files "C:\Program Files"
SET PATH=C:\Program Files\Nodejs;%PATH%
GOTO gitcheck

:gitcheck
git --version
echo %ERRORLEVEL%
IF %ERRORLEVEL% == 0 (echo Git is already installed in your System & GOTO angular)
GOTO gitdownload

:gitdownload
echo Git is not installed on your system
echo Downloading Git
powershell -Command "Invoke-WebRequest https://github.com/git-for-windows/git/releases/download/v2.28.0.windows.1/Git-2.28.0-64-bit.exe -OutFile C:\EidolaInstall\git.exe"
pause
GOTO gitinstall

:gitinstall
echo.
IF NOT EXIST C:\EidolaInstall mkdir C:\EidolaInstall
echo Installing Git
powershell -Command "C:\EidolaInstall\git.exe InstallAllUsers=1 PrependPath=1 Include_test=0"
IF NOT EXIST C:\Program-Files mklink /J C:\Program-Files "C:\Program Files"
SET PATH=C:\Program Files\Git\cmd\git.exe;%PATH% 
echo Please finish the Git installation and then
pause
echo -------------------Successfully installed Git-------------------------
GOTO angular

:angular
IF NOT EXIST C:\Program-Files mklink /J C:\Program-Files "C:\Program Files"
SET npm=C:\Program-Files\nodejs\npm
echo.
call ng --version
echo %ERRORLEVEL%
if %ERRORLEVEL% == 0 (echo Angular is already installed on your system & GOTO pm2)
echo Angular could not be found.Installing Angular..
SET PATH=C:\Users\%username%\AppData\Roaming\npm;%PATH% 
call %npm% install -g @angular/cli@latest
echo -------------------Successfully installed Angular-------------------------

:pm2
call pm2 --version
echo %ERRORLEVEL%
if %ERRORLEVEL% == 0 (echo pm2 is already installed on your system & GOTO git)
echo pm2 could not be found.Installing pm2..
SET PATH=C:\Users\%username%\AppData\Roaming\npm;%PATH% 
call %npm% install pm2@latest -g
echo -------------------Successfully installed pm2-------------------------

:git
IF NOT EXIST eidola mkdir eidola
cd eidola
IF NOT EXIST niharola\.git (git clone https://github.com/nihar-ranjan-samantaray/niharola.git & cd niharola & GOTO eidolapublicapi)
REM git config core.sparsecheckout true
REM echo Source/eidolapublicapi/*>> .git/info/sparse-checkout
REM echo Source/eidolapublicportal/*>> .git/info/sparse-checkout
REM git remote add -f origin https://1centroxy.visualstudio.com/_git/Eidola
REM git pull origin Dev
echo Doing a Git Pull
cd niharola
git checkout -b local_Dev
git branch --set-upstream-to remotes/origin/Dev
git pull
echo -------------------Successfully done Git pull -------------------------
GOTO eidolapublicapi

:eidolapublicapi
cd Source\eidolapublicapi
echo Upgrading PIP
python -m pip install --upgrade pip
echo Installing virtualenv
pip install virtualenv
virtualenv myenv

call .\myenv\Scripts\activate && pip install -r requirements.txt
echo -------------------Successfully installed all python requirements-------------------------
IF NOT EXIST migrations (echo No migration folder hence creating database & python manage.py db init & echo init done..)
echo found migrations folder.
call python manage.py db migrate && python manage.py db upgrade
call pm2 start manage.py --name eidolapublicapi --interpreter=python -- run
echo Eidola Public API is running on localhost:5000
echo Press any key to run Eidola Public Portal and install its npm modules
pause
GOTO eidolapublicportal

:eidolapublicportal
cd ..\eidolapublicportal
IF NOT EXIST node_modules (echo Performing npm install & call %npm% install & echo -------------------Successfully installed npm-------------------------)
echo Found node_modules folder.
echo.
echo Performing ng serve
call pm2 start node_modules\@angular\cli\bin\ng --name eidolapublicportal -- serve
cd ..\..\..\..\
echo List of applcation running on pm2
call pm2 list all
echo If you want to stop any application then
GOTO stop

:stop
echo.
echo 1: Stop Eidola Public API
echo 2: Stop Eidola Public Portal
echo 3: Restart All
echo 4: Stop All
echo 5: Deactivate and Exit
echo.

set /p x=Choose what you want : 
IF '%x%' == '1' GOTO NUM_1
IF '%x%' == '2' GOTO NUM_2
IF '%x%' == '3' GOTO NUM_3
IF '%x%' == '4' GOTO NUM_4
IF '%x%' == '5' GOTO NUM_5
call deactivate

:NUM_1
echo "Stopping Eidola Public API"
call pm2 stop eidolapublicapi
GOTO stop

:NUM_2
echo "Stopping Eidola Public Portal"
call pm2 stop eidolapublicportal
GOTO stop

:NUM_3
echo "Starting Both Eidola Public API and Portal"
call pm2 start eidolapublicapi
call pm2 start eidolapublicportal
GOTO stop

:NUM_4
echo "Stopping Both Eidola Public API and Portal"
call pm2 stop eidolapublicapi
call pm2 stop eidolapublicportal
GOTO stop


:NUM_5
call deactivate
