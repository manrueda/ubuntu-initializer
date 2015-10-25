#!/bin/bash
clear

if [ "$(id -u)" != "0" ]; then
	echo "Sorry, you are not root."
	exit 1
fi
REAL_USER=$(who am i | awk '{print $1}')
echo "This script will create some custom folders, install a lot of basic applications, etc..."

echo "Creating folders"
mkdir /junk &> /dev/null
mkdir /junk/logs &> /dev/null
sudo chown -R $REAL_USER:$REAL_USER /junk &> /dev/null
mkdir ~/dev &> /dev/null
sudo chown -R $REAL_USER:$REAL_USER ~/dev &> /dev/null


echo "Creating Booksmarks"
echo "file:///junk junk" >> ~/.config/gtk-3.0/bookmarks
echo "file://${HOME}/dev dev" >> ~/.config/gtk-3.0/bookmarks


echo "Adding apt sources"
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D2C19886 &> /dev/null
echo deb http://repository.spotify.com stable non-free | sudo tee /etc/apt/sources.list.d/spotify.list
echo deb http://ppa.launchpad.net/tualatrix/ppa/ubuntu trusty main | sudo tee /etc/apt/sources.list.d/tualatrix-ubuntu-ppa-trusty.list
echo deb http://ppa.launchpad.net/noobslab/icons/ubuntu vivid main | sudo tee /etc/apt/sources.list.d/noobslab-ubuntu-icons-vivid.list

echo "Update apt-get"
sudo apt-get update &> /dev/null


echo "Installing apt applications"
sudo apt-get -y install git ubuntu-tweak spotify-client terminator aircrack-ng p7zip-full unrar vlc browser-plugin-vlc android-tools-adb android-tools-fastboot virtualbox ultra-flat-icons libappindicator1 libindicator7 zip unzip laptop-mode-tools &> /dev/null
sudo apt-get -y upgrade &> /dev/null

echo "Installing flat theme"
mkdir ~/.themes &> /dev/null
mkdir ~/.themes/Fantabulous &> /dev/null
sudo chown -R $REAL_USER:$REAL_USER ~/.themes &> /dev/null
git clone https://github.com/anmoljagetia/Flatabulous.git ~/.themes/Fantabulous --depth 0 &> /dev/null

gsettings set org.gnome.desktop.interface gtk-theme "Fantabulous" &> /dev/null
gsettings set org.gnome.desktop.interface icon-theme "Ultra-Flat" &> /dev/null

echo "Tweaks"
gsettings set com.canonical.indicator.session show-real-name-on-panel true &> /dev/null

echo "Installing other applications"
echo "	--> Heroku Toolbelt"
wget -O- https://toolbelt.heroku.com/install-ubuntu.sh | sh &> /dev/null

mkdir _temp &> /dev/null
cd _temp &> /dev/null

echo "	--> Google Chrome"
wget --output-document=google-chrome-stable_current_amd64.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb &> /dev/null
sudo dpkg -i google-chrome-stable_current_amd64.deb &> /dev/null

echo "	--> Atom.io"
wget --output-document=atom.deb https://atom.io/download/deb &> /dev/null
sudo dpkg -i atom.deb &> /dev/null

echo "	--> Sublime Text 3"
wget --output-document=sublime-text_build-3095_amd64.deb http://c758482.r82.cf2.rackcdn.com/sublime-text_build-3095_amd64.deb &> /dev/null
sudo dpkg -i sublime-text_build-3095_amd64.deb &> /dev/null

echo "	--> Craking Sublime Text"
sudo printf '\x39' | sudo dd seek=$((0xd703)) conv=notrunc bs=1 of=/opt/sublime_text/sublime_text &> /dev/null

cd ..
rm -rf _temp &> /dev/null

echo "Installing and initializing NVM"
wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.29.0/install.sh | bash &> /dev/null

#this avoid to re-open the console
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

nvm install stable &> /dev/null
nvm alias default stable &> /dev/null

echo "Installing NPM global packages"
npm install -g bower grunt-cli gulp istanbul node-inspector serve tape &> /dev/null

echo "Installing Atom.io packages"
/usr/bin/apm install jade-autocompile minimap travis-ci-status file-icons git-plus minimap-highlight-selected atom-typescript atom-material-ui atom-material-syntax atom-material-syntax-light &> /dev/null

#Add custom terminal configurations
echo "" >> ~/.bashrc
echo "H_NODE=\"not found\"" >> ~/.bashrc
echo "H_NPM=\"not found\"" >> ~/.bashrc
echo "H_BOWER=\"not found\"" >> ~/.bashrc
echo "H_GRUNT=\"not found\"" >> ~/.bashrc
echo "H_NVM=\"not found\"" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "if h_bin_loc=\"\$(type -p node)\" || ! [ -z \"\$h_bin_loc\" ]; then" >> ~/.bashrc
echo "  H_NODE=\$(node -v)" >> ~/.bashrc
echo "fi" >> ~/.bashrc
echo "if h_bin_loc=\"\$(type -p npm)\" || ! [ -z \"\$h_bin_loc\" ]; then" >> ~/.bashrc
echo "  H_NPM=\"v\$(npm -v)\"" >> ~/.bashrc
echo "fi" >> ~/.bashrc
echo "if h_bin_loc=\"\$(type -p bower)\" || ! [ -z \"\$h_bin_loc\" ]; then" >> ~/.bashrc
echo "  H_BOWER=\"v\$(bower --version)\"" >> ~/.bashrc
echo "fi" >> ~/.bashrc
echo "if h_bin_loc=\"\$(type -p grunt)\" || ! [ -z \"\$h_bin_loc\" ]; then" >> ~/.bashrc
echo "  IFS=' ' read -a array <<< \"\$(grunt --version)\"" >> ~/.bashrc
echo "  H_GRUNT=\"\${array[1]}\"" >> ~/.bashrc
echo "fi" >> ~/.bashrc
echo "if h_bin_loc=\"\$(type -p nvm)\" || ! [ -z \"\$h_bin_loc\" ]; then" >> ~/.bashrc
echo "  H_NVM=\"v\$(nvm --version)\"" >> ~/.bashrc
echo "fi" >> ~/.bashrc
echo "" >> ~/.bashrc
echo "echo -e \"\e[1;34mNode: \$H_NODE\e[0m	\e[1;95mNPM: \$H_NPM\e[0m	\e[1;96mNVM: \$H_NVM\e[0m	\e[1;93mGrunt: \$H_GRUNT\e[0m	\e[1;91mBower: \$H_BOWER\e[0m\"" >> ~/.bashrc
echo "PS1=\"\[\e[38;5;46m\]\u\[\e[m\] \[\e[1;34m\]\w\[\e[m\] \[\e[1;32m\]\\$\[\e[m\] \[\e[38;5;46m\]\"" >> ~/.bashrc
echo "" >> ~/.bashrc

read -p "Do you wish to restart the system?" yn
case $yn in
	[Yy]* ) sudo shutdown -r now;;
	[Nn]* ) exit;;
	* ) echo "Please answer yes or no.";;
esac
