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
