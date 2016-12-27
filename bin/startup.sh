echo "Remove amazon shopping ads"
echo "##########################"

sudo apt-get remove unity-lens-shopping

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
