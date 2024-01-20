rem batch file
@echo off
rem Current weather in Inazawa
rem echo Fetching data from tenki.jp...

set python_exe=D:\Python\Python-3.9.7\python.exe
set home=%userprofile%\Documents\test\

set pyCode=%home%get_tenki_1h.py
set psCode=%home%get_tenki_new.ps1
set txtFile=%home%get_tenki_1h.txt

%python_exe% %pyCode% > %txtFile%
powershell -ExecutionPolicy RemoteSigned "%psCode% 0 %txtFile%"

:: Earthquake alert notification
rem echo Fetching data from jma.go.jp...
set pyCode=%home%list_quake.py
set txtFile=%home%list_quake.txt
%python_exe% %pyCode% > %txtFile%
rem timeout /T 5
powershell -ExecutionPolicy RemoteSigned "%psCode% 1 %txtFile%"

