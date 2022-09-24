sudo apt-get update
sudo apt-get install git
sudo apt-get install nim
nimble install docopt -y
git clone https://github.com/MrEnder0/Grid9.git
cd Grid9
nim c -d:release main
export PATH=$PATH:~$PWD/main