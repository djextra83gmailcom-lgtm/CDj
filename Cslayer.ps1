# Requires -RunAsAdministrator
Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "Cslayp v1.0 - Setup & Debloat Utility"
$form.Size = New-Object System.Drawing.Size(520, 620)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)
$form.ForeColor = [System.Drawing.Color]::White

# Helper to create checkboxes
function Add-Check { param($text, $x, $y, $checked=$true) $c = New-Object System.Windows.Forms.CheckBox; $c.Text = $text; $c.Location = New-Object System.Drawing.Point($x, $y); $c.Size = New-Object System.Drawing.Size(220, 24); $c.Checked = $checked; $form.Controls.Add($c); return $c }

$lblPreset = New-Object System.Windows.Forms.Label; $lblPreset.Text = "Select Preset:"; $lblPreset.Location = New-Object System.Drawing.Point(20, 20); $form.Controls.Add($lblPreset)
$cbPreset = New-Object System.Windows.Forms.ComboBox; $cbPreset.Location = New-Object System.Drawing.Point(130, 18); $cbPreset.Size = New-Object System.Drawing.Size(160, 25)
$cbPreset.Items.AddRange(@("Custom", "Debloat", "CDj", "Default")); $cbPreset.SelectedIndex = 2; $form.Controls.Add($cbPreset)

$gbDebloat = New-Object System.Windows.Forms.GroupBox; $gbDebloat.Text = "Debloat & Telemetry"; $gbDebloat.Location = New-Object System.Drawing.Point(20, 60); $gbDebloat.Size = New-Object System.Drawing.Size(460, 150); $gbDebloat.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbDebloat)
$chkWidgets = Add-Check "Widgets" 15 25; $gbDebloat.Controls.Add($chkWidgets)
$chkOneDrive = Add-Check "OneDrive" 15 50; $gbDebloat.Controls.Add($chkOneDrive)
$chkBloat = Add-Check "Bloatware Apps & Games" 15 75; $gbDebloat.Controls.Add($chkBloat)
$chkTelemetry = Add-Check "Telemetry & DiagTrack" 230 25; $gbDebloat.Controls.Add($chkTelemetry)
$chkTasks = Add-Check "Scheduled Tasks" 230 50; $gbDebloat.Controls.Add($chkTasks)

$gbApps = New-Object System.Windows.Forms.GroupBox; $gbApps.Text = "Apps & Tools"; $gbApps.Location = New-Object System.Drawing.Point(20, 225); $gbApps.Size = New-Object System.Drawing.Size(460, 180); $gbApps.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbApps)
$chkScoop = Add-Check "Scoop CLI (git, neovim, etc)" 15 25; $gbApps.Controls.Add($chkScoop)
$chkFont = Add-Check "JetBrainsMono-NF & Cursor" 15 50; $gbApps.Controls.Add($chkFont)
$chkZen = Add-Check "Zen Browser" 15 75; $gbApps.Controls.Add($chkZen)
$chkWindhawk = Add-Check "Windhawk + GitHub Mods" 15 100; $gbApps.Controls.Add($chkWindhawk)
$chkPowerShell = Add-Check "PowerShell Profile Dir" 15 125; $gbApps.Controls.Add($chkPowerShell)

$cbPreset.Add_SelectedIndexChanged({
    switch ($cbPreset.SelectedItem) {
        "Debloat" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$false; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true }
        "CDj"     { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$true; $chkPowerShell.Checked=$true }
        "Default" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true }
    }
})

$btnRun = New-Object System.Windows.Forms.Button; $btnRun.Text = "START SETUP"; $btnRun.Location = New-Object System.Drawing.Point(150, 430); $btnRun.Size = New-Object System.Drawing.Size(200, 45); $btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204); $btnRun.ForeColor = [System.Drawing.Color]::White; $btnRun.Font = New-Object System.Drawing.Font("SegoeUI", 10, [System.Drawing.FontStyle]::Bold); $form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar; $progressBar.Location = New-Object System.Drawing.Point(20, 495); $progressBar.Size = New-Object System.Drawing.Size(460, 25); $progressBar.Style = "Marquee"; $progressBar.Visible = $false; $form.Controls.Add($progressBar)

$btnRun.Add_Click({
    $form.Enabled = $false
    $progressBar.Visible = $true
    
    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') { Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0 }

    if ($chkWidgets.Checked) { winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements --accept-package-agreements -EA 0 }
    if ($chkOneDrive.Checked) { "Microsoft.OneDrive" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 } }
    if ($chkBloat.Checked) { "Microsoft.GetHelp","Microsoft.WindowsFeedbackHub","Microsoft.YourPhone","Microsoft.People","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.MicrosoftSolitaireCollection","Microsoft.549981C3F5F10" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 } }
    if ($chkTelemetry.Checked) {
        "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection","HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" | ForEach-Object { Set-ItemProperty -Path $_ -Name "AllowTelemetry" -Type DWord -Value 0 -EA 0 }
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Type DWord -Value 0 -EA 0
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type DWord -Value 0 -EA 0
        "DiagTrack","dmwappushservice","wercon" | ForEach-Object { Stop-Service $_ -EA 0; Set-Service $_ -StartupType Disabled -EA 0 }
    }
    if ($chkTasks.Checked) {
        "\Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser","\Microsoft\Windows\Application Experience\ProgramDataUpdater","\Microsoft\Windows\Autochk\Proxy","\Microsoft\Windows\Customer Experience Improvement Program\Consolidator" | ForEach-Object { Disable-ScheduledTask -TaskName $_ -EA 0 }
    }

    if ($chkScoop.Checked -or $chkFont.Checked) {
        Set-ExecutionPolicy RemoteSigned -Scope Process -Force -EA 0
        if (-not (Get-Command scoop -EA 0)) { iex (irm get.scoop.sh) }
        scoop bucket add extras -EA 0; scoop bucket add nerd-fonts -EA 0
        if ($chkScoop.Checked) { scoop install git fastfetch yazi fzf starship neovim -EA 0 }
        if ($chkFont.Checked) { scoop install JetBrainsMono-NF breeze-cursor -EA 0 }
    }

    $wingetApps = @()
    if ($chkZen.Checked) { $wingetApps += "Zen-Browser.Zen" }
    if ($chkWindhawk.Checked) { $wingetApps += "Windhawk.Windhawk" }
    if ($wingetApps.Count -gt 0) {
        winget install --id $wingetApps --scope user -e --silent --accept-source-agreements --accept-package-agreements -EA 0
    }

    if ($chkWindhawk.Checked) {
        $whMods = "$env:APPDATA\Windhawk\Engine\Mods"
        if (-not (Test-Path $whMods)) { New-Item -ItemType Directory -Path $whMods -Force | Out-Null }
        @("alt-tab-delay-remover.whm","per-monitor-alt-tab.whm","taskbar-styler.whm","start-menu-styler.whm") | ForEach-Object { Invoke-WebRequest -Uri "https://raw.githubusercontent.com/djextra83gmailcom-lgtm/CDj/main/windhawk/$_" -OutFile "$whMods\$_" -EA 0 }
    }

    if ($chkFont.Checked) {
        "UserStyle","Scheme Source" | ForEach-Object { Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name $_ -Value 1 -EA 0 }
        Set-ItemProperty -Path 'HKCU:\Control Panel\Cursors' -Name '(Default)' -Value 'Breeze' -EA 0
    }

    if ($chkPowerShell.Checked) {
        New-Item -ItemType Directory -Path "$HOME\Documents\PowerShell" -Force | Out-Null
    }

    $progressBar.Visible = $false
    [System.Windows.Forms.MessageBox]::Show("Setup finished successfully!", "Cslayp", 0, 64)
    $form.Close()
})

[void]$form.ShowDialog()
