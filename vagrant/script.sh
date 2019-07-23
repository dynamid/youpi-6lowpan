#!/bin/bash
set -e

echo deb http://ftp.debian.org/debian stretch-backports main contrib > /etc/apt/sources.list.d/stretch-backports.list

DEBIAN_FRONTEND=noninteractive apt-get update -y
DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
DEBIAN_FRONTEND=noninteractive apt-get install -y dpkg-* curl wget git gcc-arm-none-eabi virtualbox-guest-dkms virtualbox-guest-x11 srecord linux-headers-$(uname -r) linux-headers-amd64 vim xorg xfce4 xfce4-terminal
#VBoxClient --seamless

# french keyboard
#sed 's/us/fr/' /etc/default/keyboard > /etc/default/keyboard
echo -e "XKBMODEL=\"pc105\"
XKBLAYOUT=\"fr\"
XKBVARIANT=\"latin9\"
XKBOPTIONS=\"terminate:ctrl_alt_bksp\"
BACKSPACE=\"guess\"" > /etc/default/keyboard

# creation de la toolchain sdcc
DEBIAN_FRONTEND=noninteractive apt-get source sdcc -y
DEBIAN_FRONTEND=noninteractive apt-get build-dep sdcc -y

cd sdcc-*+dfsg/debian/patches/
wget http://blog.ruecker.fi/wp-content/uploads/2015/02/04_makefile_mcs51
echo $'04_makefile_mcs51' >> series
cd ../..

dpkg-buildpackage -b
#dpkg-buildpackage -b
cd ..
dpkg -i sdcc*.deb

# obtention de contiki
git clone https://github.com/contiki-os/contiki.git
#git clone https://github.com/g-oikonomou/contiki.git
cd contiki
git submodule update --init --recursive
cd ..
chmod a+rwx contiki -R

# outil de flash CC2531
git clone https://github.com/dashesy/cc-tool.git

#firefox coap
wget -q https://ftp.mozilla.org/pub/firefox/releases/55.0.3/linux-x86_64/fr/firefox-55.0.3.tar.bz2
tar -xvjf firefox-55.0.3.tar.bz2
#echo "alias firefoxCopper=\"firefox/firefox\""

git clone https://github.com/mkovatsc/Copper.git
head Copper/README.md -n 38 | tail -n 21 > HOWTOINSTALLFIREFOX.INFO.md

#mosquitto MQTT
DEBIAN_FRONTEND=noninteractive apt-get install mosquitto* -y

#uniflash
wget -q http://software-dl.ti.com/ccs/esd/uniflash/uniflash_sl.5.0.0.2289.run
DEBIAN_FRONTEND=noninteractive apt-get install libgconf-2-4 -y
ln -s /lib/x86_64-linux-gnu/libudev.so.1.6.5 /usr/lib/libudev.so.0
chmod +x uniflash_sl.5.0.0.2289.run
./uniflash_sl.5.0.0.2289.run --mode unattended
#echo "alias uniflash=\"/opt/ti/uniflash_5.0.0/node_webkit/nw\"" >> .bashrc

echo "additions to .bashrc"
script_bashrc.sh
reboot
