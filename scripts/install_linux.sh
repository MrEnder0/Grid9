if [ -x "$(command -v apt-get)" ]; then
    echo "Package manager identified as apt-get. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="apt-get"
elif [ -x "$(command -v pacman)" ]; then
    echo "Package manager identified as pacman. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="pacman"
elif [ -x "$(command -v apk)" ]; then
    echo "Package manager identified as apk. You may have to enter sudo password or enter su mode to continue."
    PACKAGE_MANAGER="apk"
else
    echo "We cant identify your package manager, we currently support apt and pacman package managers, if your system does use one of these please report this bug."
    exit 1
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
fi
echo "Installation complete. If you get any errors about permissions when running Grid9 try running the Grid9 with sudo command before."