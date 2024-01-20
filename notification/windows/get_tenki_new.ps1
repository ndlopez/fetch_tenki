<# Display as a toast message on Windows Notification #>
# $gotFile = $args[0]
# $txtFile=($env:USERPROFILE)+"\Documents\test\" + $gotFile

$aux = ""
$sw = $args[0]
$txtFile = $args[1]

$dat = Get-Content $txtFile

if ($sw -eq 0){
    $curr = ($dat[1] -Split "=")[1]
    $next = ($dat[2] -Split "=")[1]
    $next2 = ($dat[3] -Split "=")[1]
    $aux = $next + $next2
}else{
    $next = ($dat[0] -Split "=")[1]
    $next2 = ($dat[1] -Split "=")[1]
    $curr = $next + $next2
    $aux = "Earthquake and Seismic Intensity Information"
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
$notify = New-Object System.Windows.Forms.NotifyIcon
$notify.Icon = [System.Drawing.SystemIcons]::Information
$notify.Visible = $true
$notify.ShowBalloonTip(0, $curr, $aux, [System.Windows.Forms.ToolTipIcon]::None)
 
