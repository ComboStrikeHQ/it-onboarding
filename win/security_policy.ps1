Write-Host "Hi, security of your computer will be enhanced with this script. `nAfter restart you will be forced to change your password. It should be at least 12 characters long.`nPress Enter to continue" -ForegroundColor Magenta
pause
<# Run PowerShell as administrator #>
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }

$userName = $env:UserName
$CdriveStatus = Get-BitLockerVolume -MountPoint 'c:'

$userName > c:\Users\$userName\Desktop\SEND_ME.txt

<# Disk Encryption #>
if ($CdriveStatus.VolumeStatus -eq 'FullyDecrypted') {
    Enable-BitLocker -MountPoint c: -UsedSpaceOnly -SkipHardwareTest -RecoveryPasswordProtector | out-file -Append c:\Users\$userName\Desktop\SEND_ME.txt
}

<# Write some info to the file for documentation purposes #>
(get-bitlockervolume -mountpoint "c:").KeyProtector.recoverypassword >> c:\Users\$userName\Desktop\SEND_ME.txt
get-wmiobject win32_bios | select serialnumber >> c:\Users\$userName\Desktop\SEND_ME.txt

<# Enforce pass policy #>
net accounts /minpwlen:12
wmic useraccount where "Name='$userName'" set passwordexpires=true
net user $userName /logonpasswordchg:yes
Write-Host "Done, thank you!`nPlease Please do not forget to send us back the file SEND_ME.txt that was saved on your desktop." -ForegroundColor Magenta
pause
