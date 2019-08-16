#!/bin/bash

if [ "$EUID" -ne 0 ]
	  then echo "Please run as root"
		    exit
fi

TEMPDIR=`mktemp -d`
echo "TEMPDIR is $TEMPDIR"

LOOPDEVBOOT=`kpartx -lsv raspbian.img | grep p1 | cut -d ' ' -f 1`
LOOPDEV=`kpartx -asv raspbian.img | grep p2 | cut -d ' ' -f 3`
echo "Loop devices are $LOOPDEVBOOT and $LOOPDEV"

mount /dev/mapper/$LOOPDEV $TEMPDIR
mount /dev/mapper/$LOOPDEVBOOT $TEMPDIR/boot
echo "Loop devices mounted in $TEMPDIR"

echo "Customizing the raspbian..."
#on active le ssh
touch $TEMPDIR/boot/ssh

#wifi configuration
YOURSSID="SSID"
YOURPASS="PASSWORD"
YOURIP="192.168.43.100/24"
YOURROUTERIP="192.168.43.1" #with internet access (smartphone)
echo -e "country=fr\nupdate_config=1\nctrl_interface=/var/run/wpa_supplicant\n\nnetwork={\nscan_ssid=1\nssid=\"$YOURSSID\"\npsk=\"$YOURPASS\"\n}" > $TEMPDIR/boot/wpa_supplicant.conf
echo -e "require dhcp_server_identifier\n\ninterface wlan0\nstatic ip_address=$YOURIP\nstatic routers=$YOURROUTERIP\nstatic domain_name_servers=$YOURROUTERIP" > $TEMPDIR/etc/dhcpcd.conf

#on set le mot de passe de l'utilisateur pi
sed -i -e 's/pi:[^:]*:/pi:$1$pilog$.8Kn5TcS0mZl0Ug5TiXPg0:/' $TEMPDIR/etc/shadow

#on set la clé ssh pour pi
mkdir $TEMPDIR/home/pi/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpHXJmHky7Gh1Z4cZI3itodZC1Wn2olvfSmNAubhmQ+t29VriAZJh9AnIfyhT15u2vDP33Mr5dlKj36XOlMu7hJQFd33c6+dchkWXaO6pnBX/0KCdnTc0wYDJeuoOY8AkuOaIdGH+SxvrbTKSalLAThFDXkutMuMJLlXHrlXATZ705Tjv/WiQoYq+Fh4bb0T56nltaCN5jW26h/rC0DmELtoTEmbffPjpcOE5LT1L8uCWaLiycUKCc6WGubhHD1yzvn5ZULAQix2/vQuYMrYrH/a+1th+d+7HkJ8Bod1gzmvKv6FOxx2SGhWiucm6UzVCfOr5yAc1iVzE3g8FUN5bt root@khamul" > $TEMPDIR/home/pi/.ssh/authorized_keys
chmod 600 $TEMPDIR/home/pi/.ssh/authorized_keys
chown 1000:1000 $TEMPDIR/home/pi/.ssh/authorized_keys



#preinstalation du 6lbr (compilation sur le raspi plus tard)
cd $TEMPDIR/home/pi
echo -e "sudo apt update\nsudo apt upgrade\nsudo apt-get install libncurses5-dev bridge-utils\nsudo sed -i '1s/^/dwc_otg.speed=1 /' /boot/cmdline.txt\n\ncd ~/6lbr/examples/6lbr/\nsudo su -c 'make all plugins tools' pi\nsudo make install\nsudo echo -e \"MODE=ROUTER\\\n\\\nRAW_ETH=0\\\nBRIDGE=1\\\nCREATE_BRIDGE=0\\\nDEV_BRIDGE=br0\\\nDEV_TAP=tap0\\\nDEV_ETH=eth0\\\nRAW_ETH_FCS=0\\\n\\\nDEV_RADIO=/dev/ttyACM0\\\nBAUDRATE=115200\\\n\\\nLOG_LEVEL=3\" > /etc/6lbr/6lbr.conf\n\nsudo /usr/lib/6lbr/bin/nvm_tool --update --channel 25 / etc/6lbr/nvm.dat\n\nsudo echo -e \"net.ipv4.ip_forward=1\\\nnet.ipv6.conf.all.forwarding=1\" >> /etc/sysctl.conf\nsudo echo -e \"auto eth0\\\nallow-hotplug eth0\\\niface eth0 inet static\\\naddress 0.0.0.0\\\n\\\nauto br0\\\niface br0 inet dhcp\\\nbridge_ports eth0\\\nbridge_stp off\\\nup echo 0> /sys/devices/virtual/net/br0/bridge/multicast_snooping\\\npost-up ip link set br0 address 'ip link show eth0 | grep ether | awk '{print \\\\$2}''\" > /etc/network/interfaces.d/eth0\n\nsudo systemctl enable 6lbr\nsudo service 6lbr start" > create6lbr.sh
chmod +x create6lbr.sh
git clone --recursive https://github.com/cetic/6lbr
chmod a+rwx 6lbr -R
cd 6lbr
git submodule sync
git submodule update --init
cd /


echo "Cleaning..."

umount $TEMPDIR/boot
umount $TEMPDIR
echo "Loop devices unmounted"

kpartx -d raspbian.img
rmdir $TEMPDIR
echo "All cleaned !"
