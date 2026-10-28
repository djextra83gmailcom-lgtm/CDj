# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium v3.0 - System App Uninstaller & Setup"
$form.Size = New-Object System.Drawing.Size(860, 560)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# Helper to create checkboxes
function Add-Check { param($text, $x, $y, $w=210, $h=24, $checked=$false) $c = New-Object System.Windows.Forms.CheckBox; $c.Text = $text; $c.Location = New-Object System.Drawing.Point($x, $y); $c.Size = New-Object System.Drawing.Size($w, $h); $c.Checked = $checked; $c.ForeColor = [System.Drawing.Color]::White; return $c }

# Top Control Bar (Preset Selector)
$lblPreset = New-Object System.Windows.Forms.Label; $lblPreset.Text = "Preset:"; $lblPreset.Location = New-Object System.Drawing.Point(20, 17); $lblPreset.Size = New-Object System.Drawing.Size(50, 20); $form.Controls.Add($lblPreset)
$cbPreset = New-Object System.Windows.Forms.ComboBox; $cbPreset.Location = New-Object System.Drawing.Point(75, 14); $cbPreset.Size = New-Object System.Drawing.Size(150, 25); $cbPreset.DropDownStyle = "DropDownList"
$cbPreset.Items.AddRange(@("Custom", "Debloat", "CDj", "Default")); $cbPreset.SelectedIndex = 2; $form.Controls.Add($cbPreset)

$lblInfo = New-Object System.Windows.Forms.Label; $lblInfo.Text = "WinToyium Dashboard — Select features or system apps to uninstall below."; $lblInfo.Location = New-Object System.Drawing.Point(240, 17); $lblInfo.Size = New-Object System.Drawing.Size(590, 20); $lblInfo.ForeColor = [System.Drawing.Color]::DarkGray; $form.Controls.Add($lblInfo)

# Column 1: Debloat & Telemetry (Left)
$gbDebloat = New-Object System.Windows.Forms.GroupBox; $gbDebloat.Text = "Debloat & Telemetry"; $gbDebloat.Location = New-Object System.Drawing.Point(20, 50); $gbDebloat.Size = New-Object System.Drawing.Size(390, 160); $gbDebloat.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbDebloat)
$chkWidgets = Add-Check "Widgets" 15 25; $gbDebloat.Controls.Add($chkWidgets)
$chkOneDrive = Add-Check "OneDrive" 15 50; $gbDebloat.Controls.Add($chkOneDrive)
$chkBloat = Add-Check "Bloatware Apps & Games" 15 75; $gbDebloat.Controls.Add($chkBloat)
$chkTelemetry = Add-Check "Telemetry & DiagTrack" 200 25; $gbDebloat.Controls.Add($chkTelemetry)
$chkTasks = Add-Check "Scheduled Tasks" 200 50; $gbDebloat.Controls.Add($chkTasks)

# Column 2: Apps & Tools (Right)
$gbApps = New-Object System.Windows.Forms.GroupBox; $gbApps.Text = "Apps & Tools (Install / Configure)"; $gbApps.Location = New-Object System.Drawing.Point(430, 50); $gbApps.Size = New-Object System.Drawing.Size(400, 160); $gbApps.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbApps)
$chkScoop = Add-Check "Scoop CLI (git, neovim, etc)" 15 25; $gbApps.Controls.Add($chkScoop)
$chkFont = Add-Check "JetBrainsMono-NF & Cursor" 15 50; $gbApps.Controls.Add($chkFont)
$chkZen = Add-Check "Zen Browser" 15 75; $gbApps.Controls.Add($chkZen)
$chkWindhawk = Add-Check "Windhawk + GitHub Mods" 200 25; $gbApps.Controls.Add($chkWindhawk)
$chkPowerShell = Add-Check "PowerShell Profile Dir" 200 50; $gbApps.Controls.Add($chkPowerShell)

# Column 3: WinToyium Universal System App Uninstaller (Full Width Bottom)
$gbManager = New-Object System.Windows.Forms.GroupBox; $gbManager.Text = "WinToyium - Universal System App Uninstaller (Edge, Bloat, etc.)"; $gbManager.Location = New-Object System.Drawing.Point(20, 220); $gbManager.Size = New-Object System.Drawing.Size(810, 225); $gbManager.ForeColor = [System.Drawing.Color]::Gold; $form.Controls.Add($gbManager)

$lblMgrDesc = New-Object System.Windows.Forms.Label; $lblMgrDesc.Text = "Check any system app or package below to completely wipe it out:"; $lblMgrDesc.Location = New-Object System.Drawing.Point(15, 20); $lblMgrDesc.Size = New-Object System.Drawing.Size(780, 20); $lblMgrDesc.ForeColor = [System.Drawing.Color]::LightYellow; $gbManager.Controls.Add($lblMgrDesc)

# Scrollable Panel for Dynamic System Apps List
$panelApps = New-Object System.Windows.Forms.Panel; $panelApps.Location = New-Object System.Drawing.Point(15, 45); $panelApps.Size = New-Object System.Drawing.Size(780, 170); $panelApps.AutoScroll = $true; $gbManager.Controls.Add($panelApps)

$systemAppsList = @(
    @{ Name = "Microsoft Edge (msedgr / MicrosoftEdge)"; Id = "Microsoft.MicrosoftEdge"; Type = "Appx" },
    @{ Name = "Microsoft Store"; Id = "Microsoft.WindowsStore"; Type = "Appx" },
    @{ Name = "Xbox App / Services"; Id = "Microsoft.XboxApp"; Type = "Appx" },
    @{ Name = "Your Phone / Phone Link"; Id = "Microsoft.YourPhone"; Type = "Appx" },
    @{ Name = "Get Help"; Id = "Microsoft.GetHelp"; Type = "Appx" },
    @{ Name = "Feedback Hub"; Id = "Microsoft.WindowsFeedbackHub"; Type = "Appx" },
    @{ Name = "People"; Id = "Microsoft.People"; Type = "Appx" },
    @{ Name = "Bing News & Weather"; Id = "Microsoft.BingNews"; Type = "Appx" },
    @{ Name = "Solitaire Collection"; Id = "Microsoft.MicrosoftSolitaireCollection"; Type = "Appx" },
    @{ Name = "Cortana"; Id = "Microsoft.549981C3F5F10"; Type = "Appx" },
    @{ Name = "Camera"; Id = "Microsoft.WindowsCamera"; Type = "Appx" },
    @{ Name = "Maps"; Id = "Microsoft.WindowsMaps"; Type = "Appx" }
)

$checkboxesApps = @()
$yPos = 5
foreach ($app in $systemAppsList) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = "$($app.Name)  [$($app.Id)]"
    $chk.Location = New-Object System.Drawing.Point(10, $yPos)
    $chk.Size = New-Object System.Drawing.Size(740, 22)
    $chk.ForeColor = [System.Drawing.Color]::White
    $chk.Tag = $app.Id
    $panelApps.Controls.Add($chk)
    $checkboxesApps += $chk
    $yPos += 26
}

# Preset Switcher Logic
$cbPreset.Add_SelectedIndexChanged({
    switch ($cbPreset.SelectedItem) {
        "Debloat" { 
            $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$false; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true 
            foreach($c in $checkboxesApps){ if($c.Tag -eq "Microsoft.MicrosoftEdge"){$c.Checked=$false} else {$c.Checked=$true} }
        }
        "CDj"     { 
            $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$true; $chkPowerShell.Checked=$true 
            foreach($c in $checkboxesApps){ $c.Checked=$true }
        }
        "Default" { 
            $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true 
            foreach($c in $checkboxesApps){ if($c.Tag -eq "Microsoft.MicrosoftEdge"){$c.Checked=$false} else {$c.Checked=$true} }
        }
    }
})

# Bottom Action Button & Progress Bar
$btnRun = New-Object System.Windows.Forms.Button; $btnRun.Text = "START WINTOYIUM SETUP"; $btnRun.Location = New-Object System.Drawing.Point(300, 460); $btnRun.Size = New-Object System.Drawing.Size(260, 45); $btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204); $btnRun.ForeColor = [System.Drawing.Color]::White; $btnRun.Font = New-Object System.Drawing.Font("SegoeUI", 9.5, [System.Drawing.FontStyle]::Bold); $form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar; $progressBar.Location = New-Object System.Drawing.Point(20, 467); $progressBar.Size = New-Object System.Drawing.Size(810, 25); $progressBar.Style = "Marquee"; $progressBar.Visible = $false; $form.Controls.Add($progressBar)

# Execution Logic
$btnRun.Add_Click({
    $btnRun.Visible = $false
    $progressBar.Visible = $true
    
    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') { Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0 }

    if ($chkWidgets.Checked) { winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements --accept-package-agreements -EA 0 }
    if ($chkOneDrive.Checked) { "Microsoft.OneDrive" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0; Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 } }
    if ($chkBloat.Checked) { 
        "Microsoft.GetHelp","Microsoft.WindowsFeedbackHub","Microsoft.YourPhone","Microsoft.People","Microsoft.BingNews","Microsoft.BingWeather","Microsoft.MicrosoftSolitaireCollection","Microsoft.549981C3F5F10" | ForEach-Object { 
            Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$_*" | Remove-AppxProvisionedPackage -Online -EA 0 
        } 
    }
    
    foreach ($chk in $checkboxesApps) {
        if ($chk.Checked) {
            $pkgId = $chk.Tag
            Get-AppxPackage -Name "*$pkgId*" -AllUsers | Remove-AppxPackage -AllUsers -EA 0
            Get-AppxProvisionedPackage -Online | Where-Object DisplayName -like "*$pkgId*" | Remove-AppxProvisionedPackage -Online -EA 0
            winget uninstall --id "$pkgId" --silent --accept-source-agreements --accept-package-agreements -EA 0
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
    [System.Windows.Forms.MessageBox]::Show("WinToyium setup finished successfully!", "WinToyium", 0, 64)
    $form.FormClosed += { [System.Environment]::Exit(0) }
    $form.Close()
})

[void]$form.ShowDialog()
