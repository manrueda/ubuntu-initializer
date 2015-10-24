#!/bin/bash
clear

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi
REAL_USER=$(who am i | awk '{print $1}')
echo "This script will create some custom folders, install a lot of basic applications, etc..."

echo "Creating folders"
mkdir /junk
mkdir /junk/logs
sudo chown -R $REAL_USER:$REAL_USER /junk
mkdir ~/dev
sudo chown -R $REAL_USER:$REAL_USER ~/dev


echo "Creating Booksmarks"
echo "file:///junk junk" >> ~/.config/gtk-3.0/bookmarks
echo "file://${HOME}/dev dev" >> ~/.config/gtk-3.0/bookmarks


echo "Adding apt sources"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
echo deb http://ppa.launchpad.net/tualatrix/ppa/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/tualatrix-ubuntu-ppa-trusty.list
echo deb http://ppa.launchpad.net/noobslab/icons/ubuntu vivid main | sudo tee /etc/apt/sources.list.d/noobslab-ubuntu-icons-vivid.list

echo "Update apt-get"
sudo apt-get update


echo "Installing apt applications"
sudo apt-get -y install git ubuntu-tweak spotify-client terminator aircrack-ng p7zip-full unrar vlc browser-plugin-vlc android-tools-adb android-tools-fastboot virtualbox ultra-flat-icons libappindicator1 libindicator7 zip unzip laptop-mode-tools

echo "Installing flat theme"
mkdir ~/.themes
mkdir ~/.themes/Fantabulous
sudo chown -R $REAL_USER:$REAL_USER ~/.themes
git clone https://github.com/anmoljagetia/Flatabulous.git ~/.themes/Fantabulous --depth 0

gsettings set org.gnome.desktop.interface gtk-theme "Fantabulous"
gsettings set org.gnome.desktop.interface icon-theme "Ultra-Flat"

echo "Tweaks"
gsettings set com.canonical.indicator.session show-real-name-on-panel true

echo "Installing other applications"
echo "	--> Heroku Toolbelt"
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh

mkdir _temp
cd _temp


echo "	--> Google Chrome"
wget --output-document=google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
sudo dpkg -i google-chrome-stable_current_amd64.deb


echo "	--> atom.io"
wget --output-document=atom.deb https://atom.io/download/deb
sudo dpkg -i atom.deb


echo "	--> Sublime Text"
wget --output-document=sublime-text_build-3095_amd64.deb http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3095_amd64.deb
sudo dpkg -i sublime-text_build-3095_amd64.deb

echo "	--> Craking Sublime Text"
sudo printf '\x39' | sudo dd seek=$((0xd703)) conv=notrunc bs=1 of=/opt/sublime_text/sublime_text

cd ..
rm -rf _temp


echo "Installing and initializing NVM"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash

#this avoid to re-open the console
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"


nvm install stable


echo "Installing NPM global packages"
npm install -g bower grunt-cli gulp istanbul node-inspector serve tape


read -p "Do you wish to restart the system?" yn
case $yn in
	[Yy]* ) sudo shutdown -r now;;
	[Nn]* ) exit;;
	* ) echo "Please answer yes or no.";;
esac
