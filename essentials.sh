#!/bin/bash 



echo -e " Essentials"

echo -e "Setting up directory"
 
echo " ***************************************************************************************** "
echo " * if you have a directory in specific file close essential.sh and run in that directory * "
echo " ***************************************************************************************** "

cd $HOME/Desktop 

mkdir  essentials
mkdir  /essentals/core

echo -e "Installling essentials" 
apt-get update
apt-get install -y build-essential
apt-get install -y gcc 
apt-get install -y git
apt-get install -y vim 
apt-get install -y wget 
apt-get install -y curl
apt-get install -y awscli
apt-get install -y inetutils-ping 
apt-get install -y make 
apt-get install -y nmap 
apt-get install -y whois 
apt-get install -y python3
apt-get install -y python-pip 
apt-get install -y perl 
apt-get install -y nikto
apt-get install -y dnsutils 
apt-get install -y net-tools
apt-get install -y zsh
apt-get install -y nano
apt-get install -y tmux
apt-get install -y html2text
apt-get install -y terminator


# Sublist3r
echo -e "Installing Sublist3r"
cd $HOME/Desktop/essentials 
git clone https://github.com/aboul3la/Sublist3r.git
cd Sublist3r/
pip install -r requirements.txt
ln -s essentials/Sublist3r/sublist3r.py /usr/local/bin/sublist3r

# Recon-ng
echo -e "Installing Recon-ng"
cd  $HOME/Desktop/essentials 
git clone https://github.com/lanmaster53/recon-ng.git 
cd recon-ng 
apt-get install -y python3-pip 
pip3 install -r REQUIREMENTS 
chmod +x recon-ng 
ln -sf essentials/recon-ng/recon-ng /usr/local/bin/recon-ng

# XSStrike
echo -e "Installing XSStrike"
cd  $HOME/Desktop/essentials
git clone https://github.com/s0md3v/XSStrike.git 
cd XSStrike 
apt-get install -y python3-pip 
pip3 install -r requirements.txt 
chmod +x xsstrike.py
ln -sf essentials/XSStrike/xsstrike.py /usr/local/bin/xsstrike

# whatweb
echo -e " Installing whatweb"
cd  $HOME/Desktop/essentials
git clone https://github.com/urbanadventurer/WhatWeb.git
cd WhatWeb
chmod +x whatweb
ln -sf  essentials/WhatWeb/whatweb /usr/local/bin/whatweb

# fierce
echo -e "Installing fierce"
python3 -m pip install fierce

# amass
echo -e "Installing amass"
export GO111MODULE=on
go get -v github.com/OWASP/Amass/v3/...

# ffuf
echo -e "Installing ffuf"
go get -u github.com/ffuf/ffuf


# SecLists
read -p "Do you want to download SecLists? y/n " -n 1 -r
echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo -e "Downloading SecLists"
    cd  $HOME/Desktop/essentials/wordlists
    git clone --depth 1 https://github.com/danielmiessler/SecLists.git
fi
