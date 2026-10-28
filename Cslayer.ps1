# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "Cslayer / WinToyium v2.0 - Modern Setup & Manager"
$form.Size = New-Object System.Drawing.Size(760, 480)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Helper to create checkboxes with modern look
function Add-Check { param($text, $x, $y, $w=210, $h=24, $checked=$true) $c = New-Object System.Windows.Forms.CheckBox; $c.Text = $text; $c.Location = New-Object System.Drawing.Point($x, $y); $c.Size = New-Object System.Drawing.Size($w, $h); $c.Checked = $checked; $c.ForeColor = [System.Drawing.Color]::White; return $c }

# Top Control Bar (Preset Selector)
$lblPreset = New-Object System.Windows.Forms.Label; $lblPreset.Text = "Preset:"; $lblPreset.Location = New-Object System.Drawing.Point(20, 22); $lblPreset.Size = New-Object System.Drawing.Size(55, 20); $form.Controls.Add($lblPreset)
$cbPreset = New-Object System.Windows.Forms.ComboBox; $cbPreset.Location = New-Object System.Drawing.Point(80, 19); $cbPreset.Size = New-Object System.Drawing.Size(160, 25); $cbPreset.DropDownStyle = "DropDownList"
$cbPreset.Items.AddRange(@("Custom", "Debloat", "CDj", "Default")); $cbPreset.SelectedIndex = 2; $form.Controls.Add($cbPreset)

$lblInfo = New-Object System.Windows.Forms.Label; $lblInfo.Text = "Select groups & features horizontally below, then hit Start."; $lblInfo.Location = New-Object System.Drawing.Point(260, 22); $lblInfo.Size = New-Object System.Drawing.Size(460, 20); $lblInfo.ForeColor = [System.Drawing.Color]::DarkGray; $form.Controls.Add($lblInfo)

# Column 1: Debloat & Telemetry (Left)
$gbDebloat = New-Object System.Windows.Forms.GroupBox; $gbDebloat.Text = "Debloat & Telemetry"; $gbDebloat.Location = New-Object System.Drawing.Point(20, 60); $gbDebloat.Size = New-Object System.Drawing.Size(340, 185); $gbDebloat.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbDebloat)
$chkWidgets = Add-Check "Widgets" 15 25; $gbDebloat.Controls.Add($chkWidgets)
$chkOneDrive = Add-Check "OneDrive" 15 55; $gbDebloat.Controls.Add($chkOneDrive)
$chkBloat = Add-Check "Bloatware Apps & Games" 15 85; $gbDebloat.Controls.Add($chkBloat)
$chkTelemetry = Add-Check "Telemetry & DiagTrack" 15 115; $gbDebloat.Controls.Add($chkTelemetry)
$chkTasks = Add-Check "Scheduled Tasks" 15 145; $gbDebloat.Controls.Add($chkTasks)

# Column 2: Apps & Tools (Right)
$gbApps = New-Object System.Windows.Forms.GroupBox; $gbApps.Text = "Apps & Tools (Install / Configure)"; $gbApps.Location = New-Object System.Drawing.Point(380, 60); $gbApps.Size = New-Object System.Drawing.Size(340, 185); $gbApps.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbApps)
$chkScoop = Add-Check "Scoop CLI (git, neovim, etc)" 15 25; $gbApps.Controls.Add($chkScoop)
$chkFont = Add-Check "JetBrainsMono-NF & Cursor" 15 55; $gbApps.Controls.Add($chkFont)
$chkZen = Add-Check "Zen Browser" 15 85; $gbApps.Controls.Add($chkZen)
$chkWindhawk = Add-Check "Windhawk + GitHub Mods" 15 115; $gbApps.Controls.Add($chkWindhawk)
$chkPowerShell = Add-Check "PowerShell Profile Dir" 15 145; $gbApps.Controls.Add($chkPowerShell)

# Bottom Row: WinToyium Universal Manager (Full Width Horizontal)
$gbManager = New-Object System.Windows.Forms.GroupBox; $gbManager.Text = "WinToyium - Universal Uninstall / Delete Manager"; $gbManager.Location = New-Object System.Drawing.Point(20, 255); $gbManager.Size = New-Object System.Drawing.Size(700, 95); $gbManager.ForeColor = [System.Drawing.Color]::Gold; $form.Controls.Add($gbManager)
$chkForceRemoveAll = Add-Check "Force Uninstall All Selected Bloatware/Apps" 15 28 320 24; $chkForceRemoveAll.ForeColor = [System.Drawing.Color]::OrangeRed; $gbManager.Controls.Add($chkForceRemoveAll)
$chkCleanDeep = Add-Check "Deep Clean Residual App Folders / Registry" 360 28 320 24; $chkCleanDeep.ForeColor = [System.Drawing.Color]::OrangeRed; $gbManager.Controls.Add($chkCleanDeep)
$lblManagerHint = New-Object System.Windows.Forms.Label; $lblManagerHint.Text = "Wipes out selected components cleanly and applies deep registry clean."; $lblManagerHint.Location = New-Object System.Drawing.Point(15, 60); $lblManagerHint.Size = New-Object System.Drawing.Size(670, 20); $lblManagerHint.ForeColor = [System.Drawing.Color]::Gray; $gbManager.Controls.Add($lblManagerHint)

# Preset Switcher Logic
$cbPreset.Add_SelectedIndexChanged({
    switch ($cbPreset.SelectedItem) {
        "Debloat" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$false; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true; $chkForceRemoveAll.Checked=$true; $chkCleanDeep.Checked=$false }
        "CDj"     { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$true; $chkPowerShell.Checked=$true; $chkForceRemoveAll.Checked=$true; $chkCleanDeep.Checked=$true }
        "Default" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true; $chkForceRemoveAll.Checked=$true; $chkCleanDeep.Checked=$false }
    }
})

# Bottom Action Button & Progress Bar
$btnRun = New-Object System.Windows.Forms.Button; $btnRun.Text = "START SETUP"; $btnRun.Location = New-Object System.Drawing.Point(260, 370); $btnRun.Size = New-Object System.Drawing.Size(220, 45); $btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204); $btnRun.ForeColor = [System.Drawing.Color]::White; $btnRun.Font = New-Object System.Drawing.Font("SegoeUI", 10, [System.Drawing.FontStyle]::Bold); $form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar; $progressBar.Location = New-Object System.Drawing.Point(20, 370); $progressBar.Size = New-Object System.Drawing.Size(700, 25); $progressBar.Style = "Marquee"; $progressBar.Visible = $false; $form.Controls.Add($progressBar)

# Execution Logic
$btnRun.Add_Click({
    $btnRun.Visible = $false
    $progressBar.Visible = $true
    
    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') { Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0 }

    if ($chkWidgets.Checked -or $chkForceRemoveAll.Checked) { winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements --accept-package-agreements -EA 0 }
    if ($chkOneDrive.Checked -or $chkForceRemoveAll.Checked) { "Microsoft.OneDrive" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 } }
    if ($chkBloat.Checked -or $chkForceRemoveAll.Checked) { 
        "Microsoft.GetHelp","Microsoft.WindowsFeedbackHub","Microsoft.YourPhone","Microsoft.People","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.MicrosoftSolitaireCollection","Microsoft.549981C3F5F10" | ForEach-Object { 
            Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 
        } 
    }
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
    [System.Windows.Forms.MessageBox]::Show("Cslayer & WinToyium setup finished successfully!", "Cslayer", 0, 64)
    $form.FormClosed += { [System.Environment]::Exit(0) }
    $form.Close()
})

[void]$form.ShowDialog()
