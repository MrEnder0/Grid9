LINUX_VERSION_NAME=`lsb_release -a`

if [[ $LINUX_VERSION_NAME == *"Ubuntu"* ]]; then
    echo "System identified as Ubuntu. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Debian"* ]]; then
    echo "System identified as Debian. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Kali"* ]]; then
    echo "System identified as Kali. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="apt"
elif [[ $LINUX_VERSION_NAME == *"Arch"* ]]; then
    echo "System identified as Arch. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="pacman"
elif [[ $LINUX_VERSION_NAME == *"Manjaro"* ]]; then
    echo "System identified as Manjaro. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="pacman"
elif [[ $LINUX_VERSION_NAME == *"Alpine"* ]]; then
    echo "System identified as Alpine. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="pacman"
else
    echo "We cant identify your linux distro, we currently support apt and pacman package managers, if your system does one of these just enter apt, pacman, or apk below."
    read PACKAGE_MANAGER
fi

if [[ $PACKAGE_MANAGER == "apt" ]]; then
    sudo apt update
    sudo apt install git
    sudo apt install nim
    sudo apt install rename
    nimble install docopt -y
    nimble install yaml -y
    git clone https://github.com/MrEnder0/Grid9

    cd Grid9/src
    rename -v 's/main/grid9/' *.nim
    nim c -d:release grid9

    sudo chmod 777 grid9
    sudo mv grid9 /usr/bin/
elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
    sudo pacman -Syyu
    sudo pacman -S git
    sudo pacman -S nim
    sudo pacman -S rename
    nimble install docopt -y
    nimble install yaml -y
    git clone https://github.com/MrEnder0/Grid9

    cd Grid9/src
    rename -v 's/main/grid9/' *.nim
    nim c -d:release grid9

    sudo chmod 777 grid9
    sudo mv grid9 /usr/bin/
elif [[ $PACKAGE_MANAGER == "apk" ]]; then
    apk update
    apk add git
    apk add nim
    nimble install docopt -y
    nimble install yaml -y
    git clone https://github.com/MrEnder0/Grid9

    cd Grid9/src
    mv main.nim grid9.nim
    nim c -d:release grid9

    chmod 777 grid9
    mv grid9 /usr/bin/
else
    echo "Unsuported package manager only apt, pacman, and apk are curently suported."
fi
echo "Installation complete. If you get any errors about permissions when running Grid9 try running the Grid9 with sudo command before."