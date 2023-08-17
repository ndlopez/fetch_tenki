:: new test
@echo off

set python_exe=D:\Python\Python-3.9.7\python.exe
set home=C:\Users\yours_truly\Documents\test\
set pyCode=%home%get_tenki_1h.py
set txtFile=%home%get_tenki_1h.txt

%python_exe% %pyCode% > %txtFile%

rem for /F "tokens=1,2,3,5,6,8,7" %%a in (%home%get_tenki_1h.txt) do (
    :: display toast
rem    set now=%%a
rem    set curr=%%b %%c %%d "Humid"%%e %%f%%g
rem )

for /F "tokens=1,2 delims==" %%i in (%home%get_tenki_1h.txt) do (
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
powershell -Command "& {Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $notify = New-Object System.Windows.Forms.NotifyIcon; $notify.Icon = [System.Drawing.SystemIcons]::Information; $notify.Visible = $true; $notify.ShowBalloonTip(0, 'Weather in Ichinomiya, Now " %now% "', '" %nex% "', [System.Windows.Forms.ToolTipIcon]::None)}"
