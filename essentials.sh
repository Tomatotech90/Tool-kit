#!/bin/bash 



echo -e " Essentials"

echo -e "Setting up directory"
 
echo " ***************************************************************************************** "
echo " * if you have a directory in specific file close essential.sh and run in that directory * "
echo " ***************************************************************************************** "

# Check whether the user has root privileges
if [ $(id -u) -ne 0 ]; then
    echo "Error: this script must be run as root"
    exit 1
fi

# Create the "essentials" and "core" directories
echo "Setting up directories..."
mkdir -p $HOME/Desktop/essentials/core
if [ $? -ne 0 ]; then
    echo "Error: unable to create directory $HOME/Desktop/essentials/core"
    exit 1
fi

# Update the package repository and install essential packages
echo "Installing essential packages..."
apt-get update
apt-get install -y build-essential gcc git vim wget curl awscli inetutils-ping make nmap whois python3 python-pip perl nikto dnsutils net-tools zsh nano tmux html2text terminator
if [ $? -ne 0 ]; then
    echo "Error: unable to install essential packages"
    exit 1
fi

# Install additional tools using git and pip
echo "Installing Sublist3r..."
cd $HOME/Desktop/essentials
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r/
pip install -r requirements.txt
ln -s $HOME/Desktop/essentials/Sublist3r/sublist3r.py /usr/local/bin/sublist3r
if [ $? -ne 0 ]; then
    echo "Error: unable to install Sublist3r"
    exit 1
fi

echo "Installing Recon-ng..."
cd $HOME/Desktop/essentials
git clone https://github.com/lanmaster53/recon-ng.git
cd recon-ng
apt-get install -y python3-pip
pip3 install -r REQUIREMENTS
chmod +x recon-ng
ln -sf $HOME/Desktop/essentials/recon-ng/recon-ng /usr/local/bin/recon-ng
if [ $? -ne 0 ]; then
    echo "Error: unable to install Recon-ng"
    exit 1
fi

echo "Installing XSStrike..."
cd $HOME/Desktop/essentials
git clone https://github.com/s0md3v/XSStrike.git
cd XSStrike
apt-get install -y python3-pip
pip3 install -r requirements.txt
chmod +x xsstrike.py
ln -sf $HOME/Desktop/essentials/XSStrike/xsstrike.py /usr/local/bin/xsstrike
if [ $? -ne 0 ]; then
    echo "Error: unable to install XSStrike"
    exit 1
fi

echo "Installing whatweb..."
cd $HOME/Desktop/essentials
git clone https://github.com/urbanadventurer/WhatWeb.git
cd WhatWeb
chmod +x whatweb
ln -sf $HOME/Desktop/essentials/WhatWeb/whatweb /usr/local/bin/whatweb
if [ $? -ne 0 ]; then
    echo "Error: unable to install whatweb"
    exit 1
fi

echo "Installing fierce..."
python3 -m pip install fierce
if [ $? -ne 0 ]; then
    echo "Error: unable to install fierce"
    exit 1
fi

echo "Installing amass..."
export GO111MODULE=on
go get -v github.com/OWASP/Amass/v3/...
if [ $? -ne 0 ]; then
    echo "Error: unable to install amass"
    exit 1
fi

# ...

echo "Installing ffuf..."
go get -u github.com/ffuf/ffuf
if [ $? -ne 0 ]; then
    echo "Error: unable to install ffuf"
    exit 1
fi

read -p "Do you want to download SecLists? (y/n) " answer
if [[ $answer == [yY] ]]; then
    echo "Downloading SecLists..."
    cd $HOME/Desktop/essentials/core
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git
    if [ $? -ne 0 ]; then
        echo "Error: unable to download SecLists"
        exit 1
    fi
fi

