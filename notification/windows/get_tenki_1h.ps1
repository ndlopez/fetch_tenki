rem Batch file
@echo off
set home=%userprofile%\Documents\test\
powershell -ExecutionPolicy RemoteSigned "%home%toast.ps1"

##main Powershell code
<# Display as a toast message on Windows Notification #>
# $gotFile = $args[0]
$myHome = ($env:USERPROFILE) + "\Documents\test\"
$pythonExe = "D:\Python\Python-3.9.7\python.exe"
$outFile = $myHome + "get_tenki_1h.txt"
$pyCode = $myHome + "get_tenki_1h.py"

# $aux = ""
# $sw = $args[0]
# $txtFile = $args[1]

function get_info {
    param([int]$sw,[string]$pyFile,[string]$txtFile)
    Start-Process -FilePath $pythonExe -ArgumentList $pyFile -RedirectStandardOutput $txtFile -Wait -NoNewWindow

    if (Test-Path $txtFile ){
        $dat = Get-Content $txtFile
        if ($sw -eq 0){
            $curr = ($dat[1] -Split "=")[1]
            $next = ($dat[2] -Split "=")[1]
            $next2 = ($dat[3] -Split "=")[1]
            $aux = $next + $next2
        }else{
            $next = ($dat[0] -Split "=")[1]
            if ($next -eq "--:--"){
                return
            }else{
                $next2 = ($dat[1] -Split "=")[1]
                $curr = $next + $next2
                $aux = "Earthquake and Seismic Intensity Information"
            }           
        }
    }
   
    Add-Type -AssemblyName System.Windows.Forms
    Add-Type -AssemblyName System.Drawing
    $notify = New-Object System.Windows.Forms.NotifyIcon
    $notify.Icon = [System.Drawing.SystemIcons]::Information
    $notify.Visible = $true
    $notify.ShowBalloonTip(0, $curr, $aux, [System.Windows.Forms.ToolTipIcon]::None)
}

get_info 0 $pyCode $outFile

$outFile = $myHome + "list_quake.txt"
$pyCode = $myHome + "list_quake.py"

get_info 1 $pyCode $outFile
