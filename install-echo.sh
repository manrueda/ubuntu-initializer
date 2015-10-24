#!/bin/bash
clear

if [ "$(id -u)" != "0" ]; then
	echo "--> Sorry, you are not root."
	exit 1
fi

echo "--> This script will create some custom folders, install a lot of basic applications, etc..."

echo "--> Creating folders"
echo "mkdir /junk"
echo "mkdir /junk/logs"
echo "mkdir ~/dev"

echo "--> Creating Booksmarks"
echo "echo ""file:///junk junk"" >> ~/.config/gtk-3.0/bookmarks"
echo "echo ""file://${HOME}/dev dev"" >> ~/.config/gtk-3.0/bookmarks"

echo "--> Adding apt sources"
echo "sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886"
echo "echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list"

echo "--> Update apt-get"
echo "sudo apt-get update"

echo "--> Installing apt applications"
echo "sudo apt-get install spotify-client terminator aircrack-ng p7zip-full unrar vlc browser-plugin-vlc android-tools-adb android-tools-fastboot virtualbox ultra-flat-icons git"

echo "--> Installing other applications"
echo "wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh"
echo "mkdir _temp"
echo "cd _temp"
echo "wget -O- https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
echo "sudo dpkg -i google-chrome-stable_current_amd64.deb"
echo "cd .."
echo "rm -rf _temp"

echo "--> Installing and initializing NVM"
echo "wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash"
echo "nvm install stable"
echo "nvm use stable"

echo "--> Installing NPM global packages"
echo "npm install -g bower grunt-cli gulp istanbul node-inspector serve tape"