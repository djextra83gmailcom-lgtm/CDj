# Requires -RunAsAdministrator
Write-Host "🚀 Running Cslayp light setup..." -ForegroundColor Cyan
# 1. Debloat
winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements --accept-package-agreements -EA 0
"Microsoft.OneDrive","Microsoft.GetHelp","Microsoft.WindowsFeedbackHub","Microsoft.YourPhone","Microsoft.People","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.MicrosoftSolitaireCollection","Microsoft.549981C3F5F10" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 }
"HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection","HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" | ForEach-Object { Set-ItemProperty -Path $_ -Name "AllowTelemetry" -Type DWord -Value 0 -EA 0 }
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Type DWord -Value 0 -EA 0
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value 0 -EA 0
"DiagTrack","dmwappushservice","wercon" | ForEach-Object { Stop-Service $_ -EA 0; Set-Service $_ -StartupType Disabled -EA 0 }
"\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser","\Microsoft\Windows\Application Experience\ProgramDataUpdater","\Microsoft\Windows\Autochk\Proxy","\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | ForEach-Object { Disable-ScheduledTask -TaskName $_ -EA 0 }
# 2. Scoop Installation
Set-ExecutionPolicy RemoteSigned -Scope Process -Force
if (-not (Get-Command scoop -EA 0)) { iex (irm get.scoop.sh) }
scoop bucket add extras -EA 0; scoop bucket add nerd-fonts -EA 0
scoop install git fastfetch yazi fzf starship neovim JetBrainsMono-NF breeze-cursor
"UserStyle","Scheme Source" | ForEach-Object { Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name $_ -Value 1 -EA 0 }
Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name '(Default)' -Value 'Breeze' -EA 0
Write-Host "🎉 Cslayp light execution finished successfully!" -ForegroundColor Green
