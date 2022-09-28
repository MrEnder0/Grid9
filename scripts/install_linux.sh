LINUX_VERSION_NAME=`lsb_release -a`

if [[ $LINUX_VERSION_NAME == *"Ubuntu"* ]]; then
    echo "System identified as Ubuntu. You may have to enter sudo password to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Debian"* ]]; then
    echo "System identified as Debian. You may have to enter sudo password to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Kali"* ]]; then
    echo "System identified as Kali. You may have to enter sudo password to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Arch"* ]]; then
    echo "System identified as Arch. You may have to enter sudo password to continue."
    PACKAGE_MANAGER="pacman"
elif [[ $LINUX_VERSION_NAME == *"Manjaro"* ]]; then
    echo "System identified as Manjaro. You may have to enter sudo password to continue."
    PACKAGE_MANAGER="pacman"
else
    echo "We cant identify your linux version, we currently support apt and pacman package managers, if your system does one of these just enter apt or pacman below."
    read PACKAGE_MANAGER
fi

if [[ $PACKAGE_MANAGER == "apt" ]]; then
    sudo apt update
    sudo apt install git
    sudo apt install nim
    sudo apt install rename
    nimble install docopt -y
    git clone https://github.com/MrEnder0/Grid9.git

    cd Grid9/src
    rename -v 's/main/grid9/' *.nim
    nim c -d:release grid9

    sudo chmod 755 grid9
    sudo mv grid9 /usr/bin/
elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
    sudo pacman -Syyu
    sudo pacman -S git
    sudo pacman -S nim
    sudo pacman -S rename
    nimble install docopt -y
    git clone https://github.com/MrEnder0/Grid9.git
    echo $PWD

    cd Grid9/src
    echo $PWD
    rename -v 's/main/grid9/' *.nim
    nim c -d:release grid9

    sudo chmod 755 grid9
    sudo mv grid9 /usr/bin/
else
    echo "Unsuported package manager only apt and pacman are curently suported."
fi