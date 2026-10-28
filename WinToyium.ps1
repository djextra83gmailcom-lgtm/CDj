# Requires -RunAsAdministrator

if ((Get-ExecutionPolicy) -ne 'Bypassed' -and (Get-ExecutionPolicy) -ne 'Unrestricted') {
    Set-ExecutionPolicy Bypass -Scope Process -Force -EA 0
}

Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing
[System.Windows.Forms.Application]::EnableVisualStyles()

$form = New-Object System.Windows.Forms.Form
$form.Text = "WinToyium - CDj Edition"
$form.Size = New-Object System.Drawing.Size(980, 670)
$form.StartPosition = "CenterScreen"
$form.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.ForeColor = [System.Drawing.Color]::FromArgb(240, 240, 240)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::FixedSingle
$form.MaximizeBox = $false

# --- Bara Laterală (Sidebar) ---
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

function Add-NavButton {
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

$btnNavAllInOne  = Add-NavButton "⚙️  Instalare & Config" 85 $true
$btnNavTweaks    = Add-NavButton "⚡  Optimizări Sistem" 145

# --- Container Conținut Principal ---
$panelContent = New-Object System.Windows.Forms.Panel
$panelContent.Location = New-Object System.Drawing.Point(234, 12)
$panelContent.Size = New-Object System.Drawing.Size(720, 605)
$panelContent.BackColor = [System.Drawing.Color]::FromArgb(15, 15, 15)
$form.Controls.Add($panelContent)

# --- TAB 1: ALL-IN-ONE ---
$pnlAllInOne = New-Object System.Windows.Forms.Panel
$pnlAllInOne.Size = New-Object System.Drawing.Size(720, 550)
$pnlAllInOne.Visible = $true
$panelContent.Controls.Add($pnlAllInOne)

# Preseturi Orizontale
$lblProfile = New-Object System.Windows.Forms.Label
$lblProfile.Text = "Preseturi:"
$lblProfile.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$lblProfile.Location = New-Object System.Drawing.Point(5, 8)
$lblProfile.Size = New-Object System.Drawing.Size(70, 25)
$lblProfile.ForeColor = [System.Drawing.Color]::FromArgb(138, 180, 248)
$pnlAllInOne.Controls.Add($lblProfile)

function Add-ProfileBtn {
    param($text, $x)
    $b = New-Object System.Windows.Forms.Button
    $b.Text = $text
    $b.Location = New-Object System.Drawing.Point($x, 5)
    $b.Size = New-Object System.Drawing.Size(125, 30)
    $b.BackColor = [System.Drawing.Color]::FromArgb(43, 44, 48)
    $b.ForeColor = [System.Drawing.Color]::FromArgb(227, 227, 225)
    $b.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
    $b.FlatAppearance.BorderSize = 0
    $b.Font = New-Object System.Drawing.Font("Segoe UI", 9, [System.Drawing.FontStyle]::Bold)
    $b.Cursor = [System.Windows.Forms.Cursors]::Hand
    $pnlAllInOne.Controls.Add($b)
    return $b
}

# Butonul pentru Presetul CDj în interfață
$btnPresetCDj = Add-ProfileBtn "Preset CDj" 80

# Butonul mare care declanșează acțiunea doar la click (fără rulare forțată)
$btnRunAction = New-Object System.Windows.Forms.Button
$btnRunAction.Text = "Rulează Presetul CDj (Instalează & Descarcă Config-urile)"
$btnRunAction.Location = New-Object System.Drawing.Point(5, 60)
$btnRunAction.Size = New-Object System.Drawing.Size(705, 45)
$btnRunAction.BackColor = [System.Drawing.Color]::FromArgb(137, 220, 235)
$btnRunAction.ForeColor = [System.Drawing.Color]::FromArgb(30, 30, 46)
$btnRunAction.FlatStyle = [System.Windows.Forms.FlatStyle]::Flat
$btnRunAction.Font = New-Object System.Drawing.Font("Segoe UI", 10, [System.Drawing.FontStyle]::Bold)
$btnRunAction.Cursor = [System.Windows.Forms.Cursors]::Hand

# Logica executată DOAR când apeși butonul din interfață
$btnRunAction.Add_Click({
    $form.Hide()

    Write-Host "=== PASUL 1: Curățarea bloatware-ului ===" -ForegroundColor Yellow
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

    Write-Host "`n=== PASUL 2: Instalarea aplicațiilor și a managerilor de pachete ===" -ForegroundColor Cyan
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

    Write-Host "`n=== PASUL 3: Pregătirea directoarelor și descărcarea config-urilor de pe GitHub ===" -ForegroundColor Green
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

    # Link-uri către fișierele RAW din repository-ul tău CDj
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

    Write-Host "`nPresetul CDj a fost instalat și configurat cu succes! 🚀" -ForegroundColor Magenta
    [System.Windows.Forms.MessageBox]::Show("Presetul CDj a fost aplicat complet!", "WinToyium", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    $form.Close()
})

$pnlAllInOne.Controls.Add($btnRunAction)

# Afișarea ferestrei UI (fără rulare automată în fundal)
[void]$form.ShowDialog()
