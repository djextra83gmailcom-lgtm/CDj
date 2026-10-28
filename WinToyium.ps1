# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium - All-in-One Utility"
$form.Size = New-Object System.Drawing.Size(1000, 680)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# --- Bara Laterală (Sidebar) ---
$panelSidebar = New-Object System.Windows.Forms.Panel
$panelSidebar.Location = New-Object System.Drawing.Point(12, 12)
$panelSidebar.Size = New-Object System.Drawing.Size(210, 620)
$panelSidebar.BackColor = [System.Drawing.Color]::FromArgb(24, 24, 24)
$form.Controls.Add($panelSidebar)

$lblBrand = New-Object System.Windows.Forms.Label
$lblBrand.Text = "WinToyium"
$lblBrand.Font = New-Object System.Drawing.Font("Segoe UI", 14, [System.Drawing.FontStyle]::Bold)
$lblBrand.Location = New-Object System.Drawing.Point(20, 20)
$lblBrand.Size = New-Object System.Drawing.Size(170, 35)
$lblBrand.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$panelSidebar.Controls.Add($lblBrand)

function Add-NavButton {
    param($text, $y, $selected=$false)
    $btn = New-Object System.Windows.Forms.Button
    $btn.Text = "   $text"
    $btn.Location = New-Object System.Drawing.Point(12, $y)
    $btn.Size = New-Object System.Drawing.Size(186, 45)
    $btn.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $btn.FlatAppearance.BorderSize = 0
    $btn.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
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

$btnNavAllInOne  = Add-NavButton "⚙️  Install & Uninst" 80 $true
$btnNavTweaks    = Add-NavButton "⚡  System Tweaks" 135

# --- Container Conținut Principal ---
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Location = New-Object System.Drawing.Point(234, 12)
$panelContent.Size = New-Object System.Drawing.Size(735, 620)
$panelContent.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.Controls.Add($panelContent)

# --- TAB 1: ALL-IN-ONE ---
$pnlAllInOne = New-Object System.Windows.Forms.Panel
$pnlAllInOne.Location = New-Object System.Drawing.Point(0, 0)
$pnlAllInOne.Size = New-Object System.Drawing.Size(735, 620)
$pnlAllInOne.Visible = $true
$panelContent.Controls.Add($pnlAllInOne)

# Etichetă Preseturi
$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Presets:"
$lblProfile.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblProfile.Location = New-Object System.Drawing.Point(10, 15)
$lblProfile.Size = New-Object System.Drawing.Size(70, 30)
$lblProfile.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$pnlAllInOne.Controls.Add($lblProfile)

function Add-ProfileBtn {
    param($text, $x)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.Location = New-Object System.Drawing.Point($x, 12)
    $b.Size = New-Object System.Drawing.Size(130, 32)
    $b.BackColor = [System.Drawing.Color]::FromArgb(43, 44, 48)
    $b.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $pnlAllInOne.Controls.Add($b)
    return $b
}

# Butonul depreset amplasat corect pe orizontală
$btnPresetCustom = Add-ProfileBtn "Preset Personal" 85

# Butonul principal de acțiune plasat sub preseturi, cu spațiu generos
$btnRunAction = New-Object System.Windows.Forms.Button
$btnRunAction.Text = "Rulează Presetul (Debloat, Scoop/Winget & Configs)"
$btnRunAction.Location = New-Object System.Drawing.Point(10, 65)
$btnRunAction.Size = New-Object System.Drawing.Size(710, 45)
$btnRunAction.BackColor = [System.Drawing.Color]::FromArgb(137, 220, 235)
$btnRunAction.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 46)
$btnRunAction.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRunAction.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRunAction.Cursor = [System.Windows.Forms.Cursors]::Hand

# Logica de execuție la apăsare
$btnRunAction.Add_Click({
    $form.Hide()

    Write-Host "=== PASUL 1: Curățarea sistemului (Debloat) ===" -ForegroundColor Yellow
    $bloatware = @(
        "Microsoft.WebExperiencePack",
        "Microsoft.GetHelp",
        "Microsoft.GetStarted",
        "Microsoft.MicrosoftEdge",
        "Microsoft.BingSearch",
        "Microsoft.BingWeather"
    )
    foreach ($app in $bloatware) {
        try {
            winget uninstall --id $app --silent --accept-source-agreements -ErrorAction SilentlyContinue
            Write-Host "S-a dezinstalat: $app" -ForegroundColor DarkGray
        } catch {
            Write-Host "Nu s-a putut elimina: $app" -ForegroundColor DarkYellow
        }
    }

    Write-Host "`n=== PASUL 2: Instalarea managerilor de pachete și a aplicațiilor ===" -ForegroundColor Cyan
    if (!(Get-Command scoop -ErrorAction SilentlyContinue)) {
        Write-Host "Se instalează Scoop..." -ForegroundColor Yellow
        Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
        iex "& {$(irm get.scoop.sh)} -RunAsAdmin"
    }

    $apps = @(
        "GlazeWM.GlazeWM",
        "VSCodium.VSCodium",
        "LocalSend.LocalSend",
        "ZenTeam.ZenBrowser"
    )
    foreach ($app in $apps) {
        Write-Host "Se instalează $app..." -ForegroundColor DarkCyan
        try {
            winget install --id $app --exact --silent --accept-source-agreements --accept-package-agreements
        } catch {
            Write-Host "Eroare la instalarea prin winget pentru $app." -ForegroundColor Red
        }
    }

    Write-Host "`n=== PASUL 3: Pregătirea directoarelor și preluarea configurațiilor ===" -ForegroundColor Green
    $configDir = "$env:USERPROFILE\.config"
    if (!(Test-Path $configDir)) {
        New-Item -ItemType Directory -Path $configDir | Out-Null
    }

    $folders = @("fastfetch", "cava", "yasb", "glazewm")
    foreach ($folder in $folders) {
        $targetPath = Join-Path $configDir $folder
        if (!(Test-Path $targetPath)) {
            New-Item -ItemType Directory -Path $targetPath -Force | Out-Null
        }
    }

    $baseUrl = "https://raw.githubusercontent.com/djextra83gmailcom-lgtn/CD/main"
    $filesToDownload = @(
        @{ Remote = "$baseUrl/Fastfetch/config.jsonc"; Local = "$configDir\fastfetch\config.jsonc" },
        @{ Remote = "$baseUrl/GlazeWM/config.yaml"; Local = "$configDir\glazewm\config.yaml" },
        @{ Remote = "$baseUrl/Yasb/config.yaml"; Local = "$configDir\yasb\config.yaml" },
        @{ Remote = "$baseUrl/Yasb/Style.css"; Local = "$configDir\yasb\Style.css" }
    )

    foreach ($file in $filesToDownload) {
        try {
            Write-Host "Se descarcă: $($file.Remote)..." -ForegroundColor DarkGray
            Invoke-WebRequest -Uri $file.Remote -OutFile $file.Local -UseBasicParsing
        } catch {
            Write-Host "Eroare la descărcarea fișierului: $($file.Local)" -ForegroundColor Red
        }
    }

    Write-Host "`nScriptul All-in-One a terminat cu succes! 🚀" -ForegroundColor Magenta
    [System.Windows.Forms.MessageBox]::Show("Toate operațiunile au fost aplicate cu succes!", "WinToyium", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $form.Close()
})

$pnlAllInOne.Controls.Add($btnRunAction)

[void]$form.ShowDialog()
