LINUX_VERSION_NAME=`lsb_release -a`

if [[ $LINUX_VERSION_NAME == *"Ubuntu"* ]];
then
    echo "System identified as Ubuntu. Enter sudo password to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Debian"* ]];
then
    echo "System identified as Debian. Enter sudo password to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Manjaro"* ]];
then
    echo "System identified as Manjaro. Enter sudo password to continue."
    PACKAGE_MANAGER="pacman"
else
    echo "We cant identify your linux version, we currently support apt and pacman package managers if your system does one of these just enter apt or pacman."
    read PACKAGE_MANAGER
fi

if [[ $PACKAGE_MANAGER == "apt" ]]; then
    sudo apt update
    sudo apt install git, nim
    nimble install docopt -y
    git clone https://github.com/MrEnder0/Grid9.git
    cd Grid9
    nim c -d:release main
    export PATH=$PATH:~$PWD/main
elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
    sudo pacman -Syyu
    sudo pacman -S git nim
    nimble install docopt -y
    git clone https://github.com/MrEnder0/Grid9.git
    cd Grid9
    nim c -d:release main
    export PATH=$PATH:~$PWD/main
else
    echo "Unsuported package manager only apt and pacman are suported."
fi