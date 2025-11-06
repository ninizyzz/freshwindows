# Set execution policy to allow script execution
Set-ExecutionPolicy Bypass -Scope Process -Force

# Activate Windows
irm https://get.activated.win | iex
Start-Sleep -Seconds 10

# Run Debloater with default options
& ([scriptblock]::Create((irm "https://debloat.raphi.re/"))) -RunDefaults
Start-Sleep -Seconds 10

# Install Chocolatey
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType]::Tls12
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
Start-Sleep -Seconds 10

# Ensure Winget is available (optional if already installed via Windows)
Get-AppxPackage -Name "Microsoft.DesktopAppInstaller" -ErrorAction SilentlyContinue | Out-Null
if (-not $?) {
    Write-Output "Winget not found. Installing via Microsoft Store..."
    Start-Process "ms-windows-store://pdp/?productid=9NBLGGH4NNS1"
    Read-Host "Press Enter after installing Winget manually from the Store"
}

# Install essential applications
choco install -y `
  googlechrome `
  vscode `
  7zip `
  vlc `
  qbittorrent `
  git `
  notepadplusplus `
  steam `
  discord `
  logitech-ghub `
  wsl `
  hyperv `
  openvpn `
  wireshark `
  virtualbox `
  golang `
  nodejs `
  docker-cli `
  powertoys `
  rufus `
  treesizefree `
  everything `
  gh `
  powershell `
  pyenv-win `
Start-Sleep -Seconds 5


# Add pyenv to the current session
$env:PYENV="${env:USERPROFILE}\.pyenv\pyenv-win"
$env:Path+=";$env:PYENV\bin;$env:PYENV\shims"

# Install Python 3.13 using pyenv
pyenv install 3.13.0
Start-Sleep -Seconds 5
pyenv global 3.13.0

# Apply common Windows settings tweaks
# Show file extensions
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name HideFileExt -Value 0

# Show hidden files
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name Hidden -Value 1

# Disable Cortana (may require reboot and may be ignored on newer builds)
If (Test-Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search") {
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0
} Else {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force | Out-Null
    New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -PropertyType DWord -Force
}

# Set dark mode
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -PropertyType DWord -Value 0 -Force | Out-Null
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -PropertyType DWord -Value 0 -Force | Out-Null

# Install Oh My Posh (prompt theming engine)
winget install JanDeDobbeleer.OhMyPosh -s winget
Start-Sleep -Seconds 5

# Add Oh My Posh with 'jandedobbeleer' theme to PowerShell 7 profile
$pws7Profile = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
if (-not (Test-Path -Path $pws7Profile)) {
    New-Item -ItemType File -Path $pws7Profile -Force | Out-Null
}

Add-Content -Path $pws7Profile -Value 'oh-my-posh init pwsh --config "$(oh-my-posh get theme jandedobbeleer --output json | ConvertFrom-Json).path" | Invoke-Expression'

# Apply VS Code settings from GitHub repo
$settingsUrl = "https://raw.githubusercontent.com/ninizyzz/freshwindows/main/settings/vscode.json"
$destPath = "$env:APPDATA\Code\User\settings.json"

Invoke-WebRequest -Uri $settingsUrl -OutFile $destPath -UseBasicParsing
