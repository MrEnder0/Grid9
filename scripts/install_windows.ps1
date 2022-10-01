$url = "https://github.com/dom96/choosenim/releases/download/v0.8.4/choosenim-0.8.4_windows_amd64.exe"

Invoke-WebRequest -Uri $url -OutFile "choosenim-0.8.4_windows_amd64.exe"
./choosenim-0.8.4_windows_amd64 --firstInstall stable

nimble install docopt -y
git clone https://github.com/MrEnder0/Grid9.git
Set-Location Grid9/src
nim c -d:release main.nim