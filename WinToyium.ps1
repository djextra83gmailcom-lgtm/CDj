# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium"
$form.Size = New-Object System.Drawing.Size(980, 670)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# --- Material 3 Sidebar Navigation ---
$panelSidebar = New-Object System.Windows.Forms.Panel
$panelSidebar.Location = New-Object System.Drawing.Point(12, 12)
$panelSidebar.Size = New-Object System.Drawing.Size(210, 605)
$panelSidebar.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
$form.Controls.Add($panelSidebar)

$lblBrand = New-Object System.Windows.Forms.Label
$lblBrand.Text = "WinToyium"
$lblBrand.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$lblBrand.Location = New-Object System.Drawing.Point(20, 24)
$lblBrand.Size = New-Object System.Drawing.Size(170, 30)
$lblBrand.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$panelSidebar.Controls.Add($lblBrand)

function Add-M3NavButton {
    param($text, $y, $selected=$false)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "   $text"
    $btn.Location = New-Object System.Drawing.Point(12, $y)
    $btn.Size = New-Object System.Drawing.Size(186, 46)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::SemiBold)
    $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft
    $btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    if ($selected) {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(58, 83, 122)
        $btn.ForeColor = [System.Drawing.Color]::FromArgb(211, 228, 255)
    } else {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
        $btn.ForeColor = [System.Drawing.Color]::FromArgb(196, 199, 197)
    }
    $panelSidebar.Controls.Add($btn)
    return $btn
}

$btnNavAllInOne  = Add-M3NavButton "⚙️  Install & Uninst" 85 $true
$btnNavTweaks    = Add-M3NavButton "⚡  System Tweaks" 145

# --- Content Area Container ---
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Location = New-Object System.Drawing.Point(234, 12)
$panelContent.Size = New-Object System.Drawing.Size(720, 605)
$panelContent.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.Controls.Add($panelContent)

# --- TAB 1: ALL-IN-ONE (Install / Uninstall & Software) ---
$pnlAllInOne = New-Object System.Windows.Forms.Panel
$pnlAllInOne.Size = New-Object System.Drawing.Size(720, 550)
$pnlAllInOne.Visible = $true
$panelContent.Controls.Add($pnlAllInOne)

# Horizontal Presets
$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Presets:"
$lblProfile.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblProfile.Location = New-Object System.Drawing.Point(5, 8)
$lblProfile.Size = New-Object System.Drawing.Size(70, 25)
$lblProfile.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$pnlAllInOne.Controls.Add($lblProfile)

function Add-M3ProfileBtn {
    param($text, $x)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.Location = New-Object System.Drawing.Point($x, 5)
    $b.Size = New-Object System.Drawing.Size(125, 30)
    $b.BackColor = [System.Drawing.Color]::FromArgb(43, 44, 48)
    $b.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Medium)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $pnlAllInOne.Controls.Add($b)
    return $b
}
$btnProfCDj      = Add-M3ProfileBtn "CDj" 80
$btnProfStandard = Add-M3ProfileBtn "Standard" 215
$btnProfDebloat  = Add-M3ProfileBtn "Debloat Only" 350

# Left Box: System Uninstaller
$gbUninst = New-Object System.Windows.Forms.GroupBox
$gbUninst.Text = "System Apps Uninstaller"
$gbUninst.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gbUninst.ForeColor = [System.Drawing.Color]::FromArgb(242, 184, 181)
$gbUninst.Location = New-Object System.Drawing.Point(5, 45)
$gbUninst.Size = New-Object System.Drawing.Size(340, 495)
$pnlAllInOne.Controls.Add($gbUninst)

$panelApps = New-Object System.Windows.Forms.Panel
$panelApps.Location = New-Object System.Drawing.Point(10, 25)
$panelApps.Size = New-Object System.Drawing.Size(320, 460)
$panelApps.AutoScroll = $true
$gbUninst.Controls.Add($panelApps)

$installedPackages = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Select-Object Name, PackageFullName -Unique | Sort-Object Name
$checkboxesApps = @()
$yPos = 10
foreach ($pkg in $installedPackages) {
    $appName = $pkg.Name
    $appFullName = $pkg.PackageFullName
    
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $appName
    $chk.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $chk.Location = New-Object System.Drawing.Point(10, $yPos)
    $chk.Size = New-Object System.Drawing.Size(295, 24)
    $chk.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
    $chk.Tag = $appFullName
    $panelApps.Controls.Add($chk)
    $checkboxesApps += $chk
    $yPos += 28
}

# Right Box: Useful Software & Package Engine
$gbSoftware = New-Object System.Windows.Forms.GroupBox
$gbSoftware.Text = "Useful Software & Packages"
$gbSoftware.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gbSoftware.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$gbSoftware.Location = New-Object System.Drawing.Point(355, 45)
$gbSoftware.Size = New-Object System.Drawing.Size(355, 495)
$pnlAllInOne.Controls.Add($gbSoftware)

$lblEngine = New-Object System.Windows.Forms.Label
$lblEngine.Text = "Engine:"
$lblEngine.Location = New-Object System.Drawing.Point(15, 25)
$lblEngine.Size = New-Object System.Drawing.Size(55, 25)
$lblEngine.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
$gbSoftware.Controls.Add($lblEngine)

$comboEngine = New-Object System.Windows.Forms.ComboBox
$comboEngine.Location = New-Object System.Drawing.Point(75, 22)
$comboEngine.Size = New-Object System.Drawing.Size(100, 25)
$comboEngine.Items.AddRange(@("Winget", "Scoop"))
$comboEngine.SelectedIndex = 0
$gbSoftware.Controls.Add($comboEngine)

$chkGit = New-Object System.Windows.Forms.CheckBox
$chkGit.Text = "Git (Scoop Req)"
$chkGit.Location = New-Object System.Drawing.Point(190, 23)
$chkGit.Size = New-Object System.Drawing.Size(140, 24)
$chkGit.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
$gbSoftware.Controls.Add($chkGit)

function Add-M3Check {
    param($text, $x, $y)
    $c = New-Object System.Windows.Forms.CheckBox
    $c.Text = $text
    $c.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $c.Location = New-Object System.Drawing.Point($x, $y)
    $c.Size = New-Object System.Drawing.Size(155, 24)
    $c.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
    return $c
}

$chkWindhawk = Add-M3Check "Windhawk" 15 65
$chkYASB     = Add-M3Check "YASB Bar" 185 65
$chkGlazeWM  = Add-M3Check "GlazeWM" 15 95
$chkYazi     = Add-M3Check "Yazi Terminal" 185 95
$chkFzf      = Add-M3Check "fzf Search" 15 125
$chkLocalSend= Add-M3Check "LocalSend" 185 125
$chkZen      = Add-M3Check "Zen Browser" 15 155

$gbSoftware.Controls.Add($chkWindhawk)
$gbSoftware.Controls.Add($chkYASB)
$gbSoftware.Controls.Add($chkGlazeWM)
$gbSoftware.Controls.Add($chkYazi)
$gbSoftware.Controls.Add($chkFzf)
$gbSoftware.Controls.Add($chkLocalSend)
$gbSoftware.Controls.Add($chkZen)

$lblCustomApp = New-Object System.Windows.Forms.Label
$lblCustomApp.Text = "Custom Package Name or ID:"
$lblCustomApp.Location = New-Object System.Drawing.Point(15, 190)
$lblCustomApp.Size = New-Object System.Drawing.Size(320, 20)
$lblCustomApp.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
$gbSoftware.Controls.Add($lblCustomApp)

$txtCustomApp = New-Object System.Windows.Forms.TextBox
$txtCustomApp.Location = New-Object System.Drawing.Point(15, 212)
$txtCustomApp.Size = New-Object System.Drawing.Size(325, 26)
$txtCustomApp.BackColor = [System.Drawing.Color]::FromArgb(43, 44, 48)
$txtCustomApp.ForeColor = [System.Drawing.Color]::White
$gbSoftware.Controls.Add($txtCustomApp)

$gbCoreDebloat = New-Object System.Windows.Forms.GroupBox
$gbCoreDebloat.Text = "Core Telemetry & Widgets"
$gbCoreDebloat.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
$gbCoreDebloat.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$gbCoreDebloat.Location = New-Object System.Drawing.Point(15, 248)
$gbCoreDebloat.Size = New-Object System.Drawing.Size(325, 235)
$gbSoftware.Controls.Add($gbCoreDebloat)

$chkWidgets  = Add-M3Check "Remove Widgets" 15 25
$chkOneDrive = Add-M3Check "Remove OneDrive" 15 55
$chkTelemetry= Add-M3Check "Disable Telemetry" 15 85
$chkTasks    = Add-M3Check "Disable Tasks" 15 115

$gbCoreDebloat.Controls.Add($chkWidgets)
$gbCoreDebloat.Controls.Add($chkOneDrive)
$gbCoreDebloat.Controls.Add($chkTelemetry)
$gbCoreDebloat.Controls.Add($chkTasks)


# --- TAB 2: SYSTEM TWEAKS ---
$pnlTweaks = New-Object System.Windows.Forms.Panel
$pnlTweaks.Size = New-Object System.Drawing.Size(720, 550)
$pnlTweaks.Visible = $false
$panelContent.Controls.Add($pnlTweaks)

$lblTweaksTitle = New-Object System.Windows.Forms.Label
$lblTweaksTitle.Text = "Advanced System Tweaks"
$lblTweaksTitle.Font = New-Object System.Drawing.Font("Segoe UI", 12, [System.Drawing.FontStyle]::Bold)
$lblTweaksTitle.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$lblTweaksTitle.Location = New-Object System.Drawing.Point(5, 10)
$lblTweaksTitle.Size = New-Object System.Drawing.Size(400, 30)
$pnlTweaks.Controls.Add($lblTweaksTitle)

$chkGameMode = Add-M3Check "Enable Ultimate Performance" 15 60
$chkAccel    = Add-M3Check "Disable Mouse Acceleration" 15 100
$chkFastBoot = Add-M3Check "Optimize Network Throttling" 15 140
$chkDarkTheme= Add-M3Check "Force System Dark Mode" 15 180
$pnlTweaks.Controls.Add($chkGameMode)
$pnlTweaks.Controls.Add($chkAccel)
$pnlTweaks.Controls.Add($chkFastBoot)
$pnlTweaks.Controls.Add($chkDarkTheme)


# --- Navigation Events ---
function Set-ActiveNavButton {
    param($activeBtn)
    foreach ($btn in @($btnNavAllInOne, $btnNavTweaks)) {
        if ($btn -eq $activeBtn) {
            $btn.BackColor = [System.Drawing.Color]::FromArgb(58, 83, 122)
            $btn.ForeColor = [System.Drawing.Color]::FromArgb(211, 228, 255)
        } else {
            $btn.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
            $btn.ForeColor = [System.Drawing.Color]::FromArgb(196, 199, 197)
        }
    }
}

$btnNavAllInOne.Add_Click({
    $pnlAllInOne.Visible = $true; $pnlTweaks.Visible = $false
    Set-ActiveNavButton $btnNavAllInOne
})

$btnNavTweaks.Add_Click({
    $pnlAllInOne.Visible = $false; $pnlTweaks.Visible = $true
    Set-ActiveNavButton $btnNavTweaks
})

# Preset logic
$btnProfCDj.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $true; $chkWindhawk.Checked = $true; $chkYASB.Checked = $true; $chkGlazeWM.Checked = $true
    $chkYazi.Checked = $true; $chkFzf.Checked = $true; $chkLocalSend.Checked = $true; $chkZen.Checked = $true
})
$btnProfStandard.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $true; $chkZen.Checked = $true; $chkLocalSend.Checked = $true
})
$btnProfDebloat.Add_Click({
    $chkWidgets.Checked = $true; $chkOneDrive.Checked = $true; $chkTelemetry.Checked = $true; $chkTasks.Checked = $true
    $chkGit.Checked = $false; $chkWindhawk.Checked = $false; $chkYASB.Checked = $false; $chkGlazeWM.Checked = $false
})


# --- BOTTOM FIXED ACTION BUTTON (START BUTTON) ---
$btnRun = New-Object System.Windows.Forms.Button
$btnRun.Text = "APPLY CHANGES & RUN"
$btnRun.Font = New-Object System.Drawing.Font("Segoe UI", 10.5, [System.Drawing.FontStyle]::Bold)
$btnRun.Location = New-Object System.Drawing.Point(234, 562)
$btnRun.Size = New-Object System.Drawing.Size(720, 48)
$btnRun.BackColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$btnRun.ForeColor = [System.Drawing.Color]::FromArgb(28, 41, 62)
$btnRun.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRun.FlatAppearance.BorderSize = 0
$btnRun.Cursor = [System.Windows.Forms.Cursors]::Hand
$form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(234, 562)
$progressBar.Size = New-Object System.Drawing.Size(720, 48)
$progressBar.Style = "Marquee"
$progressBar.Visible = $false
$form.Controls.Add($progressBar)


# --- Execution Handler ---
$btnRun.Add_Click({
    $btnRun.Visible = $false
    $progressBar.Visible = $true

    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') { 
        Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0 
    }

    foreach ($chk in $checkboxesApps) {
        if ($chk.Checked) {
            $fullPkg = $chk.Tag
            Remove-AppxPackage -Package $fullPkg -AllUsers -ErrorAction SilentlyContinue
            Remove-AppxProvisionedPackage -Online -PackageName $fullPkg -ErrorAction SilentlyContinue
        }
    }

    if ($chkWidgets.Checked) { winget uninstall --id "Microsoft.Windows.Widgets_8wekyb3d8bbwe" --silent --accept-source-agreements -EA 0 }
    if ($chkOneDrive.Checked) { "Microsoft.OneDrive" | ForEach-Object { Get-AppxPackage -Name $_ -AllUsers | Remove-AppxPackage -AllUsers -EA 0 } }
    if ($chkTelemetry.Checked) {
        Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type DWord -Value 0 -EA 0
    }

    $engine = $comboEngine.SelectedItem
    $appsToInstall = @()
    if ($chkWindhawk.Checked) { $appsToInstall += "Windhawk.Windhawk" }
    if ($chkYASB.Checked)     { $appsToInstall += "yasb" }
    if ($chkGlazeWM.Checked)  { $appsToInstall += "GlazeWM.GlazeWM" }
    if ($chkYazi.Checked)     { $appsToInstall += "sxyazi.yazi" }
    if ($chkFzf.Checked)      { $appsToInstall += "junegunn.fzf" }
    if ($chkLocalSend.Checked){ $appsToInstall += "LocalSend.LocalSend" }
    if ($chkZen.Checked)      { $appsToInstall += "Zen-Browser.Zen" }

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
        scoop bucket add nerd-fonts -EA 0
        foreach ($app in $appsToInstall) {
            scoop install $app -EA 0
        }
    }

    $progressBar.Visible = $false
    [System.Windows.Forms.MessageBox]::Show("WinToyium Material 3 execution finished successfully!", "WinToyium", 0, 64)
    $form.FormClosed += { [System.Environment]::Exit(0) }
    $form.Close()
})

[void]$form.ShowDialog()
