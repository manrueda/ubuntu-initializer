#!/bin/bash
clear

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi

echo "This script will create some custom folders, install a lot of basic applications, etc..."

echo "Creating folders"
mkdir /junk
mkdir /junk/logs
mkdir ~/dev

echo "Creating Booksmarks"
echo "file:///junk junk" >> ~/.config/gtk-3.0/bookmarks
echo "file://${HOME}/dev dev" >> ~/.config/gtk-3.0/bookmarks

echo "Adding apt sources"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list

echo "Update apt-get"
sudo apt-get update

echo "Installing apt applications"
sudo apt-get install spotify-client terminator aircrack-ng p7zip-full unrar vlc browser-plugin-vlc android-tools-adb android-tools-fastboot virtualbox ultra-flat-icons git

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
wget --output-document=sublime-text_build-3083_amd64.deb http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3083_amd64.deb
sudo dpkg -i sublime-text_build-3083_amd64.deb

echo "	--> Craking Sublime Text"
sublPath=$(which subl)
printf '\x39' | dd seek=$((0xcbe3)) conv=notrunc bs=1 of=$sublPath

cd ..
rm -rf _temp

echo "Installing and initializing NVM"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash
nvm install stable
nvm use stable

echo "Installing NPM global packages"
npm install -g bower grunt-cli gulp istanbul node-inspector serve tape