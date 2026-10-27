# Requires -RunAsAdministrator
Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "Cslayp v1.0 - Setup & Debloat Utility"
$form.Size = New-Object System.Drawing.Size(520, 640)$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(30, 30, 30)$form.ForeColor = [System.Drawing.Color]::White

# Helper to create checkboxes
function Add-Check { param($text,$x, $y,$checked=$true)$c = New-Object System.Windows.Forms.CheckBox; $c.Text = $text; $c.Location = New-Object System.Drawing.Point($x,$y); $c.Size = New-Object System.Drawing.Size(220, 24);$c.Checked = $checked; $form.Controls.Add($c); return$c }

$lblPreset = New-Object System.Windows.Forms.Label; $lblPreset.Text = "Select Preset:"; $lblPreset.Location = New-Object System.Drawing.Point(20, 20);$form.Controls.Add($lblPreset)$cbPreset = New-Object System.Windows.Forms.ComboBox; $cbPreset.Location = New-Object System.Drawing.Point(130, 18);$cbPreset.Size = New-Object System.Drawing.Size(160, 25)
$cbPreset.Items.AddRange(@("Custom", "Debloat", "CDj", "Default")); $cbPreset.SelectedIndex = 2; $form.Controls.Add($cbPreset)

$gbDebloat = New-Object System.Windows.Forms.GroupBox; $gbDebloat.Text = "Debloat & Telemetry"; $gbDebloat.Location = New-Object System.Drawing.Point(20, 60);$gbDebloat.Size = New-Object System.Drawing.Size(460, 150); $gbDebloat.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbDebloat)$chkWidgets = Add-Check "Widgets" 15 25; $gbDebloat.Controls.Add($chkWidgets)
$chkOneDrive = Add-Check "OneDrive" 15 50; $gbDebloat.Controls.Add($chkOneDrive)$chkBloat = Add-Check "Bloatware Apps & Games" 15 75; $gbDebloat.Controls.Add($chkBloat)
$chkTelemetry = Add-Check "Telemetry & DiagTrack" 230 25; $gbDebloat.Controls.Add($chkTelemetry)$chkTasks = Add-Check "Scheduled Tasks" 230 50; $gbDebloat.Controls.Add($chkTasks)

$gbApps = New-Object System.Windows.Forms.GroupBox; $gbApps.Text = "Apps & Tools"; $gbApps.Location = New-Object System.Drawing.Point(20, 225);$gbApps.Size = New-Object System.Drawing.Size(460, 205); $gbApps.ForeColor = [System.Drawing.Color]::Cyan; $form.Controls.Add($gbApps)$chkScoop = Add-Check "Scoop CLI (git, neovim, etc)" 15 25; $gbApps.Controls.Add($chkScoop)
$chkFont = Add-Check "JetBrainsMono-NF & Cursor" 15 50; $gbApps.Controls.Add($chkFont)$chkZen = Add-Check "Zen Browser" 15 75; $gbApps.Controls.Add($chkZen)
$chkWinToyium = Add-Check "WinToyium" 15 100; $gbApps.Controls.Add($chkWinToyium)$chkWindhawk = Add-Check "Windhawk + GitHub Mods" 15 125; $gbApps.Controls.Add($chkWindhawk)$chkPowerShell = Add-Check "PowerShell Profile Dir" 15 150; $gbApps.Controls.Add($chkPowerShell)

$cbPreset.Add_SelectedIndexChanged({
    switch ($cbPreset.SelectedItem) {
        "Debloat" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$false; $chkWinToyium.Checked=$false; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true }
        "CDj"     { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWinToyium.Checked=$true; $chkWindhawk.Checked=$true; $chkPowerShell.Checked=$true }
        "Default" { $chkWidgets.Checked=$true; $chkOneDrive.Checked=$true; $chkBloat.Checked=$true; $chkTelemetry.Checked=$true; $chkTasks.Checked=$true; $chkScoop.Checked=$true; $chkFont.Checked=$true; $chkZen.Checked=$true; $chkWinToyium.Checked=$true; $chkWindhawk.Checked=$false; $chkPowerShell.Checked=$true }
    }
})

$btnRun = New-Object System.Windows.Forms.Button; $btnRun.Text = "START SETUP"; $btnRun.Location = New-Object System.Drawing.Point(150, 450); $btnRun.Size = New-Object System.Drawing.Size(200, 45);$btnRun.BackColor = [System.Drawing.Color]::FromArgb(0, 122, 204); $btnRun.ForeColor = [System.Drawing.Color]::White; $btnRun.Font = New-Object System.Drawing.Font("SegoeUI", 10, [System.Drawing.FontStyle]::Bold); $form.Controls.Add($btnRun)

$progressBar = New-Object System.Windows.Forms.ProgressBar; $progressBar.Location = New-Object System.Drawing.Point(20, 515); $progressBar.Size = New-Object System.Drawing.Size(460, 25);$progressBar.Style = "Marquee"; $progressBar.Visible =$false; $form.Controls.Add($progressBar)

$btnRun.Add_Click({
    $form.Enabled =$false
    $progressBar.Visible =$true
    
    if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-
