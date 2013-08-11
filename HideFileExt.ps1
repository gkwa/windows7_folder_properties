# http://stackoverflow.com/questions/4491999/configure-windows-explorer-folder-options-through-powershell

$key = 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced'

# Set-ItemProperty $key ShowSuperHidden 1
# Set-ItemProperty $key Hidden 1

# Uncheck "Hide extensions for known file types"
Set-ItemProperty $key HideFileExt 0

Stop-Process -processname explorer
