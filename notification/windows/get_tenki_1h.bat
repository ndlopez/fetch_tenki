@echo off
rem Current weather in Inazawa
rem echo Fetching data from tenki.jp...

set python_exe=D:\Python\Python-3.9.7\python.exe
set home=C:\Users\yoursTruly\Documents\test\

set pyCode=%home%get_tenki_1h.py

set txtFile=%home%get_tenki_1h.txt


%python_exe% %pyCode% > %txtFile%

rem timeout /T 5

for /F "tokens=1,2 delims==" %%i in (%txtFile%) do (
   :: echo %%a %%b
   if %%i == curr ( 
       set now=%%j
       rem echo %now%
   )
   if %%i == next ( 
       set nex=%%j
       rem echo %nex%
   )
)
:: display toast
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Inazawa, Now " %now% "', '" %nex% "', [System.Windows.Forms.ToolTipIcon]::None)}"

:: Earthquake alert notification
rem echo Fetching data from jma.go.jp...
set pyCode=%home%list_quake.py
set txtFile=%home%list_quake.txt
set title="Earthquake and Seismic Intensity Information"
%python_exe% %pyCode% > %txtFile%
rem timeout /T 5

for /F "tokens=1,2 delims==" %%i in (%txtFile%) do (
   if %%i == when (
       set when=%%j
   )
   if %%i == what (
       set what=%%j
   )
)
rem echo dat%when%
:: display toast
if /I not "%when%"==" -:--" (
   powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, '" %title% "', '" %when% %what%"', [System.Windows.Forms.ToolTipIcon]::None)}"
)
