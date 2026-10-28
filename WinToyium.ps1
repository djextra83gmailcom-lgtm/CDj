# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium - CDj Edition"
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

# --- TAB 1: ALL-IN-ONE ---
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
    $b.FlatAppearance.BorderSize = 0$b.Font = New-Object System.Drawing.Font("Segoe UI",
