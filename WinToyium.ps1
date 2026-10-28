# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium"
$form.Size = New-Object System.Drawing.Size(980, 670)$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox =$false

# --- Sidebar Navigation ---
$panelSidebar = New-Object System.Windows.Forms.Panel
$panelSidebar.Location = New-Object System.Drawing.Point(12, 12)
$panelSidebar.Size = New-Object System.Drawing.Size(210, 605)$panelSidebar.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
$form.Controls.Add($panelSidebar)

$lblBrand = New-Object System.Windows.Forms.Label
$lblBrand.Text = "WinToyium"
$lblBrand.Font = New-Object System.Drawing.Font("Segoe UI", 13, [System.Drawing.FontStyle]::Bold)
$lblBrand.Location = New-Object System.Drawing.Point(20, 24)
$lblBrand.Size = New-Object System.Drawing.Size(170, 30)$lblBrand.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$panelSidebar.Controls.Add($lblBrand)

function Add-NavButton {
    param($text, $y,$selected=$false)$btn = New-Object System.Windows.Forms.Button
    $btn.Text = "   $text"
    $btn.Location = New-Object System.Drawing.Point(12,$y)
    $btn.Size = New-Object System.Drawing.Size(186, 46)$btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0$btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::SemiBold)
    $btn.TextAlign = [System.Drawing.ContentAlignment]::MiddleLeft$btn.Cursor = [System.Windows.Forms.Cursors]::Hand
    
    if ($selected) {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(58, 83, 122)$btn.ForeColor = [System.Drawing.Color]::FromArgb(211, 228, 255)
    } else {
        $btn.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)$btn.ForeColor = [System.Drawing.Color]::FromArgb(196, 199, 197)
    }
    $panelSidebar.Controls.Add($btn)
    return $btn
}

$btnNavAllInOne  = Add-NavButton "⚙️  Install & Uninst" 85 $true$btnNavTweaks    = Add-NavButton "⚡  System Tweaks" 145

# --- Content Area Container ---
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Location = New-Object System.Drawing.Point(234, 12)
$panelContent.Size = New-Object System.Drawing.Size(720, 605)$panelContent.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.Controls.Add($panelContent)

# --- TAB 1: ALL-IN-ONE (Install / Uninstall & Software) ---
$pnlAllInOne = New-Object System.Windows.Forms.Panel
$pnlAllInOne.Size = New-Object System.Drawing.Size(720, 550)
$pnlAllInOne.Visible =$true
$panelContent.Controls.Add($pnlAllInOne)

# Horizontal Presets
$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Presets:"
$lblProfile.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblProfile.Location = New-Object System.Drawing.Point(5, 8)
$lblProfile.Size = New-Object System.Drawing.Size(70, 25)$lblProfile.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$pnlAllInOne.Controls.Add($lblProfile)

function Add-ProfileBtn {
    param($text, $x)$b = New-Object System.Windows.Forms.Button
    $b.Text =$text
    $b.Location = New-Object System.Drawing.Point($x, 5)
    $b.Size = New-Object System.Drawing.Size(125, 30)$b.BackColor = [System.Drawing.Color]::FromArgb(43, 44, 48)
    $b.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)$b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0$b.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Medium)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $pnlAllInOne.Controls.Add($b)
    return $b
}
$btnProfCDj      = Add-ProfileBtn "CDj" 80
$btnProfStandard = Add-ProfileBtn "Standard" 215
$btnProfDebloat  = Add-ProfileBtn "Debloat Only" 350

# Left Box: System Uninstaller
$gbUninst = New-Object System.Windows.Forms.GroupBox
$gbUninst.Text = "System Apps Uninstaller"
$gbUninst.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gbUninst.ForeColor = [System.Drawing.Color]::FromArgb(242, 184, 181)
$gbUninst.Location = New-Object System.Drawing.Point(5, 45)$gbUninst.Size = New-Object System.Drawing.Size(340, 495)
$pnlAllInOne.Controls.Add($gbUninst)

$panelApps = New-Object System.Windows.Forms.Panel
$panelApps.Location = New-Object System.Drawing.Point(10, 25)$panelApps.Size = New-Object System.Drawing.Size(320, 460)
$panelApps.AutoScroll =$true
$gbUninst.Controls.Add($panelApps)

$installedPackages = Get-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Select-Object Name, PackageFullName -Unique | Sort-Object Name
$checkboxesApps = @()$yPos = 10
foreach ($pkg in$installedPackages) {
    $appName =$pkg.Name
    $appFullName =$pkg.PackageFullName
    
    $chk = New-Object System.Windows.Forms.CheckBox
    $chk.Text = $appName$chk.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Regular)
    $chk.Location = New-Object System.Drawing.Point(10, $yPos)$chk.Size = New-Object System.Drawing.Size(295, 24)
    $chk.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)$chk.Tag = $appFullName$panelApps.Controls.Add($chk)$checkboxesApps += $chk$yPos += 28
}

# Right Box: Useful Software & Package Engine
$gbSoftware = New-Object System.Windows.Forms.GroupBox
$gbSoftware.Text = "Useful Software & Packages"
$gbSoftware.Font = New-Object System.Drawing.Font("Segoe UI", 9.5, [System.Drawing.FontStyle]::Bold)
$gbSoftware.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$gbSoftware.Location = New-Object System.Drawing.Point(355, 45)$gbSoftware.Size = New-Object System.Drawing.Size(355, 495)
$pnlAllInOne.Controls.Add($gbSoftware)

$lblEngine = New-Object System.Windows.Forms.Label
$lblEngine.Text = "Engine:"
$lblEngine.Location = New-Object System.Drawing.Point(15, 25)
$lblEngine.Size = New-Object System.Drawing.Size(55, 25)$lblEngine.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
$gbSoftware.Controls.Add($lblEngine)

$comboEngine = New-Object System.Windows.Forms.ComboBox
$comboEngine.Location = New-Object System.Drawing.Point(75, 22)
$comboEngine.Size = New-Object System.Drawing.Size(100, 25)$comboEngine.Items.AddRange(@("Winget", "Scoop"))
$comboEngine.SelectedIndex = 0
$gbSoftware.Controls.Add($comboEngine)

$chkGit = New-Object System.Windows.Forms.CheckBox
$chkGit.Text = "Git (Scoop Req)"
$chkGit.Location = New-Object System.Drawing.Point(190, 23)$chkGit.Size = New-Object System.Drawing.Size
