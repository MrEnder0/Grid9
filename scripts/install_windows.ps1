$url = "https://github.com/dom96/choosenim/releases/download/v0.8.4/choosenim-0.8.4_windows_amd64.exe"

Write-Output "Installing Nim... (0/3)"
Invoke-WebRequest -Uri $url -OutFile "choosenim.exe"
./choosenim --firstInstall stable

Write-Output "Installing dependencies... (1/3)"
nimble install docopt -y

Write-Output "Compiling Grid9... (2/3)"
git clone https://github.com/MrEnder0/Grid9.git
Set-Location Grid9/src
nim c -d:release main.nim

Write-Output "Finished successfully! (3/3)"