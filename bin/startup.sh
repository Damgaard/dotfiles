echo "Initial setup and installing basic packages"
echo "###########################################"

sudo apt-get update
sudo apt-get upgrade

echo ""
echo "Setup dotfiles"
echo "##############"

sudo apt-get install git
git clone https://github.com/Damgaard/dotfiles.git
git config --global user.name "Andreas Damgaard Pedersen"
git config --global user.email "andreas.damgaard.p@gmail.com"

# TODO: Run a script from the dotfiles repo to setup symlins
# This file has not yet been created.

echo "Remove amazon shopping ads"
echo "##########################"

sudo apt-get remove unity-lens-shopping

echo
echo "Install various general tools"
echo "#############################"

sudo apt-get install vim terminator zsh gitk keepassx gimp chromium-browser

echo
echo "Install skype"
echo "#############"

sudo dpkg --add-architecture i386
sudo add-apt-repository "deb http://archive.canonical.com/ $(lsb_release -sc) partner"
sudo apt-get update && sudo apt-get install skype pulseaudio:i386

echo
echo "Install Dropbox"
echo "###############"

sudo apt-key adv --keyserver pgp.mit.edu --recv-keys 5044912E
sudo add-apt-repository "deb http://linux.dropbox.com/ubuntu $(lsb_release -sc) main"
sudo apt-get update && sudo apt-get install dropbox

echo
echo "Install python specific tools"
echo "#############################"

sudo apt-get install python-pip python-virtualenv

echo
echo "Intialize projects dir"
echo "######################"

mkdir ~/projects
cd ~/projects
git clone https://github.com/Damgaard/PyImgur.git
git clone https://github.com/praw-dev/praw.git
cd ~
