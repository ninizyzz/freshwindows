# 🪟 freshwindows

A PowerShell script to automate the setup of a clean Windows installation.  
Installs essential tools, applies system tweaks, configures development environments, and sets up VS Code.

---

## ⚙️ What This Script Does

- Activates Windows (optional)
- Removes bloatware
- Installs:
  - Chocolatey & Winget
  - Browsers, dev tools, virtualization tools
  - Python (via pyenv) and Node.js
  - Docker CLI, Git, Go, and more
- Applies:
  - Windows settings (dark mode, hidden files, etc.)
  - PowerShell 7 with Oh My Posh prompt
  - VS Code with custom settings

---

## 🚀 How to Use (from a fresh Windows install)

1. Open **PowerShell as Administrator**
2. Run this one-liner:

```powershell
Set-ExecutionPolicy Bypass -Scope Process -Force
irm https://raw.githubusercontent.com/ninizyzz/freshwindows/main/setup.ps1 | iex
