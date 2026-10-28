# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium - Modern Windows Optimizer"
$form.Size = New-Object System.Drawing.Size(920, 600)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 18)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# --- Sidebar Menu (Left) ---
$panelSidebar = New-Object System.Windows.Forms.Panel
$panelSidebar.Location = New-Object System.Drawing.Point(0, 0)
$panelSidebar.Size = New-Object System.Drawing.Size(200, 560)
$panelSidebar.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28)
$form.Controls.Add($panelSidebar)

$lblBrand = New-Object System.Windows.Forms.Label
$lblBrand.Text = "WinToyium"
$lblBrand.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblBrand.Location = New-Object System.Drawing.Point(20, 20)
$lblBrand.Size = New-Object System.Drawing.Size(160, 35)
$lblBrand.ForeColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$panelSidebar.Controls.Add($lblBrand)

function Add-NavButton {
    param($text, $y, $selected=$false)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "  $text"
    $btn.Location = New-Object System.Drawing.Point(10, $y)
    $btn.Size = New-Object System.Drawing.Size(180, 42)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Regular)
    $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    if ($selected) {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
        $btn.ForeColor = [System.Drawing.Color]::White
    } else {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28)
        $btn.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    }
    $panelSidebar.Controls.Add($btn)
    return $btn
}

$btnNavDebloat   = Add-NavButton "📥 Debloat & Install" 80 $true
$btnNavUninst    = Add-NavButton "🗑️ System Uninstaller" 130
$btnNavTweaks    = Add-NavButton "⚡ Wintoys Tweaks" 180

# --- Content Panels Container ---
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Location = New-Object System.Drawing.Point(210, 15)
$panelContent.Size = New-Object System.Drawing.Size(680, 520)
$panelContent.BackColor = [System.Drawing.Color]::FromArgb(18, 18, 18)
$form.Controls.Add($panelContent)

# --- PANEL 1: DEBLOAT & INSTALLER ---
$pnlDebloat = New-Object System.Windows.Forms.Panel
$pnlDebloat.Size = New-Object System.Drawing.Size(680, 520)
$pnlDebloat.Visible = $true
$panelContent.Controls.Add($pnlDebloat)

$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Select Setup Profile:"
$lblProfile.Font = New-Object System.Drawing.Font("Segoe UI", 11, [System.Drawing.FontStyle]::Bold)
$lblProfile.Location = New-Object System.Drawing.Point(10, 10)
$lblProfile.Size = New-Object System.Drawing.Size(200, 25)
$pnlDebloat.Controls.Add($lblProfile)

function Add-ProfileBtn {
    param($text, $x)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.Location = New-Object System.Drawing.Point($x, 40)
    $b.Size = New-Object System.Drawing.Size(145, 32)
    $b.BackColor = [System.Drawing.Color]::FromArgb(45, 45, 45)
    $b.ForeColor = [System.Drawing.Color]::White
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $pnlDebloat.Controls.Add($b)
    return $b
}
$btnProfCDj      = Add-ProfileBtn "CDj" 10
$btnProfStandard = Add-ProfileBtn "Standard" 165
$btnProfDebloat  = Add-ProfileBtn "Debloat Only" 320

# Debloat Checkboxes Group
$gbDBox = New-Object System.Windows.Forms.GroupBox
$gbDBox.Text = "System Debloat"
$gbDBox.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$gbDBox.ForeColor = [System.Drawing.Color]::Cyan
$gbDBox.Location = New-Object System.Drawing.Point(10, 85)
$gbDBox.Size = New-Object System.Drawing.Size(660, 110)
$pnlDebloat.Controls.Add($gbDBox)

function Add-DCheck {
    param($text, $x, $y)
    $c = New-Object System.Windows.Forms.CheckBox
    $c.Text = $text
    $c.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $c.Location = New-Object System.Drawing.Point($x, $y)
    $c.Size = New-Object System.Drawing.Size(220, 25)
    $c.ForeColor = [System.Drawing.Color]::White
    $c.Checked = $true
    return $c
}
$chkWidgets  = Add-DCheck "Remove Widgets" 15 25
$chkOneDrive = Add-DCheck "Remove OneDrive" 15 55
$chkBloat    = Add-DCheck "Remove Xbox and Games" 15 80
$chkTelemetry= Add-DCheck "Disable Telemetry" 340 25
$chkTasks    = Add-DCheck "Disable Tracking Tasks" 340 55

$gbDBox.Controls.Add($chkWidgets)
$gbDBox.Controls.Add($chkOneDrive)
$gbDBox.Controls.Add($chkBloat)
$gbDBox.Controls.Add($chkTelemetry)
$gbDBox.Controls.Add($chkTasks)

# App Installer Group
$gbInstall = New-Object System.Windows.Forms.GroupBox
$gbInstall.Text = "App Installer and Package Manager"
$gbInstall.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$gbInstall.ForeColor = [System.Drawing.Color]::Cyan
$gbInstall.Location = New-Object System.Drawing.Point(10, 205)
$gbInstall.Size = New-Object System.Drawing.Size(660, 225)
$pnlDebloat.Controls.Add($gbInstall)

$lblMgr = New-Object System.Windows.Forms.Label
$lblMgr.Text = "Package Engine:"
$lblMgr.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblMgr.Location = New-Object System.Drawing.Point(15, 28)
$lblMgr.Size = New-Object System.Drawing.Size(120, 25)
$lblMgr.ForeColor = [System.Drawing.Color]::White
$gbInstall.Controls.Add($lblMgr)

$comboEngine = New-Object System.Windows.Forms.ComboBox
$comboEngine.Location = New-Object System.Drawing.Point(140, 25)
$comboEngine.Size = New-Object System.Drawing.Size(140, 25)
$comboEngine.Items.AddRange(@("Winget", "Scoop"))
$comboEngine.SelectedIndex = 0
$gbInstall.Controls.Add($comboEngine)

$chkGit = Add-DCheck "Install Git" 320 25
$gbInstall.Controls.Add($chkGit)

$chkLocalSend = Add-DCheck "Install LocalSend" 15 65
$gbInstall.Controls.Add($chkLocalSend)

$chkZen = Add-DCheck "Install Zen Browser" 230 65
$gbInstall.Controls.Add($chkZen)

$chkWindhawk = Add-DCheck "Install Windhawk" 440 65
$gbInstall.Controls.Add($chkWindhawk)

$lblCustomApp = New-Object System.Windows.Forms.Label
$lblCustomApp.Text = "Install custom package by Name or ID:"
$lblCustomApp.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$lblCustomApp.Location = New-Object System.Drawing.Point(15, 110)
$lblCustomApp.Size = New-Object System.Drawing.Size(300, 25)
$lblCustomApp.ForeColor = [System.Drawing.Color]::White
$gbInstall.Controls.Add($lblCustomApp)

$txtCustomApp = New-Object System.Windows.Forms.TextBox
$txtCustomApp.Location = New-Object System.Drawing.Point(15, 140)
$txtCustomApp.Size = New-Object System.Drawing.Size(630, 28)
$txtCustomApp.BackColor = [System.Drawing.Color]::FromArgb(40, 40, 40)
$txtCustomApp.ForeColor = [System.Drawing.Color]::White
$txtCustomApp.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
$gbInstall.Controls.Add($txtCustomApp)

# --- PANEL 2: SYSTEM UNINSTALLER ---
$pnlUninst = New-Object System.Windows.Forms.Panel
$pnlUninst.Size = New-Object System.Drawing.Size(680, 520)
$pnlUninst.Visible = $false
$panelContent.Controls.Add($pnlUninst)

$lblUninstTitle = New-Object System.Windows.Forms.Label
$lblUninstTitle.Text = "Universal System App Uninstaller"
$lblUninstTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblUninstTitle.ForeColor = [System.Drawing.Color]::Gold
$lblUninstTitle.Location = New-Object System.Drawing.Point(10, 10)
$lblUninstTitle.Size = New-Object System.Drawing.Size(400, 30)
$pnlUninst.Controls.Add($lblUninstTitle)

$panelApps = New-Object System.Windows.Forms.Panel
$panelApps.Location = New-Object System.Drawing.Point(10, 50)
$panelApps.Size = New-Object System.Drawing.Size(660, 400)
$panelApps.AutoScroll = $true
$pnlUninst.Controls.Add($panelApps)

$systemAppsList = @(
    @{ Name = "Microsoft Edge"; Id = "Microsoft.MicrosoftEdge" },
    @{ Name = "Microsoft Store"; Id = "Microsoft.WindowsStore" },
    @{ Name = "Xbox Services"; Id = "Microsoft.XboxApp" },
    @{ Name = "Phone Link"; Id = "Microsoft.YourPhone" },
    @{ Name = "Get Help"; Id = "Microsoft.GetHelp" },
    @{ Name = "Feedback Hub"; Id = "Microsoft.WindowsFeedbackHub" },
    @{ Name = "People App"; Id = "Microsoft.People" },
    @{ Name = "Bing News and Weather"; Id = "Microsoft.BingNews" },
    @{ Name = "Solitaire Collection"; Id = "Microsoft.MicrosoftSolitaireCollection" },
    @{ Name = "Camera App"; Id = "Microsoft.WindowsCamera" },
    @{ Name = "Maps App"; Id = "Microsoft.WindowsMaps" }
)

$checkboxesApps = @()
$yPos = 10
foreach ($app in $systemAppsList) {
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = "$($app.Name)  [$($app.Id)]"
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Regular)
    $chk.Location = New-Object System.Drawing.Point(15, $yPos)
    $chk.Size = New-Object System.Drawing.Size(600, 25)
    $chk.ForeColor = [System.Drawing.Color]::White
    $chk.Tag = $app.Id
    $panelApps.Controls.Add($chk)
    $checkboxesApps += $chk
    $yPos += 30
}

# --- PANEL 3: WINTOYS TWEAKS ---
$pnlTweaks = New-Object System.Windows.Forms.Panel
$pnlTweaks.Size = New-Object System.Drawing.Size(680, 520)
$pnlTweaks.Visible = $false
$panelContent.Controls.Add($pnlTweaks)

$lblTweaksTitle = New-Object System.Windows.Forms.Label
$lblTweaksTitle.Text = "Wintoys Power Tweaks and Performance"
$lblTweaksTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblTweaksTitle.ForeColor = [System.Drawing.Color]::Gold
$lblTweaksTitle.Location = New-Object System.Drawing.Point(10, 10)
$lblTweaksTitle.Size = New-Object System.Drawing.Size(400, 30)
$pnlTweaks.Controls.Add($lblTweaksTitle)

$chkGameMode = Add-DCheck "Enable Ultimate Performance" 15 60
$chkAccel    = Add-DCheck "Disable Mouse Acceleration" 15 100
$chkFastBoot = Add-DCheck "Optimize Network Throttling" 15 140
$chkDarkTheme= Add-DCheck "Force System Dark Mode" 15 180
$pnlTweaks.Controls.Add($chkGameMode)
$pnlTweaks.Controls.Add($chkAccel)
$pnlTweaks.Controls.Add($chkFastBoot)
$pnlTweaks.Controls.Add($chkDarkTheme)

# --- Navigation Switch Logic ---
$btnNavDebloat.Add_Click({
    $pnlDebloat.Visible = $true; $pnlUninst.Visible = $false; $pnlTweaks.Visible = $false
    $btnNavDebloat.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212); $btnNavDebloat.ForeColor = [System.Drawing.Color]::White
    $btnNavUninst.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavUninst.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $btnNavTweaks.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavTweaks.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
})

$btnNavUninst.Add_Click({
    $pnlDebloat.Visible = $false; $pnlUninst.Visible = $true; $pnlTweaks.Visible = $false
    $btnNavUninst.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212); $btnNavUninst.ForeColor = [System.Drawing.Color]::White
    $btnNavDebloat.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavDebloat.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $btnNavTweaks.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavTweaks.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
})

$btnNavTweaks.Add_Click({
    $pnlDebloat.Visible = $false; $pnlUninst.Visible = $false; $pnlTweaks.Visible = $true
    $btnNavTweaks.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212); $btnNavTweaks.ForeColor = [System.Drawing.Color]::White
    $btnNavDebloat.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavDebloat.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
    $btnNavUninst.BackColor = [System.Drawing.Color]::FromArgb(28, 28, 28); $btnNavUninst.ForeColor = [System.Drawing.Color]::FromArgb(200, 200, 200)
})

# Profile Presets Logic (CDj, Standard, Debloat Only)
$btnProfCDj.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkBloat.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $true; $chkLocalSend.Checked = $true; $chkZen.Checked = $true; $chkWindhawk.Checked = $true
})
$btnProfStandard.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkBloat.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $true; $chkZen.Checked = $true; $chkLocalSend.Checked = $false; $chkWindhawk.Checked = $false
})
$btnProfDebloat.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkBloat.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $false; $chkLocalSend.Checked = $false; $chkZen.Checked = $false; $chkWindhawk.Checked = $false
})

# --- Bottom Execute Button & Progress Bar ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "APPLY SELECTED CHANGES"
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRun.Location = New-Object System.Drawing.Point(210, 500)
$btnRun.Size = New-Object System.Drawing.Size(680, 42)
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 120, 212)
$btnRun.ForeColor = [System.Drawing.Color]::White
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(210, 500)
$progressBar.Size = New-Object System.Drawing.Size(680, 42)
$progressBar.Style = "Marquee"
$progressBar.Visible = $false
$form.Controls.Add($progressBar)

# --- Execution Script Handler ---
$btnRun.Add_Click({
    $btnRun.Visible = $false
    $progressBar.Visible = $true

    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') { 
        Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0 
    }

    if ($chkWidgets.Checked) { winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements --accept-package-agreements -EA 0 }
    if ($chkOneDrive.Checked) { "Microsoft.OneDrive" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0 } }
    if ($chkBloat.Checked) { 
        "Microsoft.XboxApp","Microsoft.BingNews","Microsoft.MicrosoftSolitaireCollection" | ForEach-Object { 
            Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0 
        } 
    }
    if ($chkTelemetry.Checked) {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -EA 0
    }

    foreach ($chk in $checkboxesApps) {
        if ($chk.Checked) {
            $pkgId = $chk.Tag
            Get-AppxPackage -Name "*$pkgId*" -AllUsers | Remove-AppxPackage -AllUsers -EA 0
            winget uninstall --id "$pkgId" --silent --accept-source-agreements --accept-package-agreements -EA 0
        }
    }

    $engine = $comboEngine.SelectedItem
    $appsToInstall = @()
    if ($chkLocalSend.Checked) { $appsToInstall += "LocalSend.LocalSend" }
    if ($chkZen.Checked) { $appsToInstall += "Zen-Browser.Zen" }
    if ($chkWindhawk.Checked) { $appsToInstall += "Windhawk.Windhawk" }
    
    if ($txtCustomApp.Text.Trim() -ne "") {
        $appsToInstall += $txtCustomApp.Text.Trim()
    }

    if ($engine -eq "Winget") {
        if ($chkGit.Checked) { winget install --id "Git.Git" --scope user -e --silent --accept-source-agreements -EA 0 }
        foreach ($app in $appsToInstall) {
            winget install --id "$app" --scope user -e --silent --accept-source-agreements --accept-package-agreements -EA 0
        }
    } else {
        if (-not (Get-Command scoop -EA 0)) { iex (irm get.scoop.sh) }
        if ($chkGit.Checked) { scoop install git -EA 0 }
        scoop bucket add extras -EA 0
        foreach ($app in $appsToInstall) {
            scoop install $app -EA 0
        }
    }

    $progressBar.Visible = $false
    [System.Windows.Forms.MessageBox]::Show("WinToyium optimization and installation completed successfully!", "WinToyium", 0, 64)
    $form.FormClosed += { [System.Environment]::Exit(0) }
    $form.Close()
})

[void]$form.ShowDialog()
