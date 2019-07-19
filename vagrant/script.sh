#!/bin/bash
set -e

sudo echo deb http://ftp.debian.org/debian stretch-backports main contrib > /etc/apt/sources.list.d/stretch-backports.list

sudo apt update -y
sudo apt upgrade -y
sudo apt install dpkg-* curl wget git gcc-arm-none-eabi virtualbox-guest-dkms virtualbox-guest-x11 srecord linux-headers-$(uname -r) -y
sudo apt install vim xorg xfce4 -y
sudo VBoxClient --seamless

# french keyboard
sudo sed 's/us/fr/' /etc/default/keyboard > /etc/default/keyboard

# creation de la toolchain sdcc
apt source sdcc -y
apt build-dep sdcc -y

cd sdcc-*+dfsg/debian/patches/
wget http://blog.ruecker.fi/wp-content/uploads/2015/02/04_makefile_mcs51
wget http://blog.ruecker.fi/wp-content/uploads/2015/02/05_incl.mk_model_huge
echo $'04_makefile_mcs51\n05_incl.mk_model_huge' >> series
cd ../..

dpkg-buildpackage -b
dpkg-buildpackage -b
cd ..
dpkg -i sdcc*.deb

# obtention de contiki
git clone https://github.com/contiki-os/contiki.git
#git clone https://github.com/g-oikonomou/contiki.git
cd contiki
git submodule update --init --recursive
sudo chmod a+rwx contiki -R

# outil de flash CC2531
git clone https://github.com/dashesy/cc-tool.git

#firefox coap
sudo apt install wget curl git -y
wget -q https://ftp.mozilla.org/pub/firefox/releases/55.0.3/linux-x86_64/fr/firefox-55.0.3.tar.bz2
tar -xvjf firefox-55.0.3.tar.bz2
#echo "alias firefoxCopper=\"firefox/firefox\""

git clone https://github.com/mkovatsc/Copper.git
head Copper/README.md -n 38 | tail -n 21 > HOWTOINSTALLFIREFOX.INFO.md

#mosquitto MQTT
sudo apt install mosquitto* -y

#uniflash
wget -q http://software-dl.ti.com/ccs/esd/uniflash/uniflash_sl.5.0.0.2289.run
sudo apt install libgconf-2-4 -y
sudo ln -s /lib/x86_64-linux-gnu/libudev.so.1.6.5 /usr/lib/libudev.so.0
sudo chmod +x uniflash_sl.5.0.0.2289.run
sudo ./uniflash_sl.5.0.0.2289.run --mode unattended
#echo "alias uniflash=\"/opt/ti/uniflash_5.0.0/node_webkit/nw\"" >> .bashrc


setxkbmap fr
echo "PATH=~/bin:\$PATH" >> .bashrc
sudo reboot
