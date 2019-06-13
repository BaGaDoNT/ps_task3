# console view change
 (Get-Host).UI.RawUI.ForegroundColor = "green"
 (Get-Host).UI.RawUI.BackgroundColor = "black"
 (Get-Host).UI.RawUI.CursorSize = 10
 (Get-Host).UI.RawUI.WindowTitle = "My Window"
 
# set default directory
 Set-Location C:\
 
# create alias for Get-Help
 Set-Alias HelpMe Get-Help
 
# add snap-in and modules
 Get-Pssnapin-Registered| Add-Pssnapin-Passthru-ErrorActionSilentlyContinue
 Get-Module-ListAvailable| Import-Module-PassThru-ErrorActionSilentlyContinue
 
# clear console screen
 Clear-Host
 
# set greeting
Write-Host "Hello, my friend !!!"