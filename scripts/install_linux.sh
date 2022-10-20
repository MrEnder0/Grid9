if [ -x "$(command -v apt-get)" ]; then
    echo "Package manager identified as apt-get. You may have to enter sudo password or enter su mode to continue. Also you may be prompted with a message from choosenim put either y or n."
    PACKAGE_MANAGER="apt-get"
elif [ -x "$(command -v pacman)" ]; then
    echo "Package manager identified as pacman. You may have to enter sudo password or enter su mode to continue. Also you may be prompted with a message from choosenim put either y or n."
    PACKAGE_MANAGER="pacman"
elif [ -x "$(command -v apk)" ]; then
    echo "Package manager identified as apk. You may have to enter sudo password or enter su mode to continue. Also you may be prompted with a message from choosenim put either y or n."
    PACKAGE_MANAGER="apk"
else
    echo "We cant identify your package manager, we currently support apt and pacman package managers, if your system does use one of these please report this bug."
    exit 1
fi

if [[ $PACKAGE_MANAGER == "apt" ]]; then
    sudo apt update
    sudo apt install git

    echo "Installing nim and project dependencies."
    curl https://nim-lang.org/choosenim/init.sh -o choosenim
    chmod +x choosenim
    ./choosenim
    export PATH=/home/$USER/.nimble/bin:$PATH
    nimble install docopt -y
    nimble install yaml -y

    echo "Compiling grid9."
    git clone https://github.com/MrEnder0/Grid9
    cd Grid9/src
    mv main.nim grid9.nim
    nim c -d:release grid9

    echo "Installing grid9."
    sudo chmod 777 grid9
    sudo mv grid9 /usr/bin/
    sudo mkdir /usr/share/Grid9/

    echo "Would you like to install the example scripts (y/n)"
    read -r INSTALL_EXAMPLES
    if [[ $INSTALL_EXAMPLES == "y" ]]; then
        echo "Installing example scripts."
        sudo mkdir /usr/share/Grid9/examples
        cd examples
        sudo mv * /usr/share/Grid9/examples
    fi
elif [[ $PACKAGE_MANAGER == "pacman" ]]; then
    sudo pacman -Syyu
    sudo pacman -S git

    echo "Installing nim and project dependencies."
    curl https://nim-lang.org/choosenim/init.sh -o choosenim
    chmod +x choosenim
    ./choosenim
    export PATH=/home/$USER/.nimble/bin:$PATH
    nimble install docopt -y
    nimble install yaml -y

    echo "Compiling grid9."
    git clone https://github.com/MrEnder0/Grid9
    cd Grid9/src
    mv main.nim grid9.nim
    nim c -d:release grid9

    echo "Installing grid9."
    sudo chmod 777 grid9
    sudo mv grid9 /usr/bin/
    sudo mkdir /usr/share/Grid9/

    echo "Would you like to install the example scripts (y/n)"
    read -r INSTALL_EXAMPLES
    if [[ $INSTALL_EXAMPLES == "y" ]]; then
        echo "Installing example scripts."
        sudo mkdir /usr/share/Grid9/examples
        cd examples
        sudo mv * /usr/share/Grid9/examples
    fi
elif [[ $PACKAGE_MANAGER == "apk" ]]; then
    apk update
    apk add git

    echo "Installing nim and project dependencies."
    apk add nim
    apk add nimble
    nimble install docopt -y
    nimble install yaml -y

    echo "Compiling grid9."
    git clone https://github.com/MrEnder0/Grid9
    cd Grid9/src
    mv main.nim grid9.nim
    nim c -d:release grid9

    echo "Installing grid9."
    chmod 777 grid9
    mv grid9 /usr/bin/
    mkdir /usr/share/Grid9/

    echo "Would you like to install the example scripts (y/n)"
    read -r INSTALL_EXAMPLES
    if [[ $INSTALL_EXAMPLES == "y" ]]; then
        echo "Installing example scripts."
        mkdir /usr/share/Grid9/examples
        cd examples
        mv * /usr/share/Grid9/examples
    fi
fi
echo "Installation complete!"
