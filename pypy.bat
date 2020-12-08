@echo off
set "$py=0"
call:construct
for /f "delims=" %%a in ('python #.py ^| findstr "3"') do set "$py=3"
del #.py
goto:%$py%
echo %$py%
echo Download python
:3
echo %$py%
echo Python 3


:construct
echo import sys; print('{0[0]}.{0[1]}'.format(sys.version_info^)^) >#.py