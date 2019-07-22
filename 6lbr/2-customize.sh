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

#on set le mot de passe de l'utilisateur pi
sed -i -e 's/pi:[^:]*:/pi:$6$HcL0ST5lcHV1K$GJIR0042dXYa6ptVt1v20Ca33EaVOk8llniTU.zAdgJBwX1AkEH6BV6ls.OwpvdKHGxiRhtPCBAKXFeyFllFI.:/' $TEMPDIR/etc/shadow

#on set la clé ssh pour pi
mkdir $TEMPDIR/home/pi/.ssh
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpHXJmHky7Gh1Z4cZI3itodZC1Wn2olvfSmNAubhmQ+t29VriAZJh9AnIfyhT15u2vDP33Mr5dlKj36XOlMu7hJQFd33c6+dchkWXaO6pnBX/0KCdnTc0wYDJeuoOY8AkuOaIdGH+SxvrbTKSalLAThFDXkutMuMJLlXHrlXATZ705Tjv/WiQoYq+Fh4bb0T56nltaCN5jW26h/rC0DmELtoTEmbffPjpcOE5LT1L8uCWaLiycUKCc6WGubhHD1yzvn5ZULAQix2/vQuYMrYrH/a+1th+d+7HkJ8Bod1gzmvKv6FOxx2SGhWiucm6UzVCfOr5yAc1iVzE3g8FUN5bt root@khamul" > $TEMPDIR/home/pi/.ssh/authorized_keys
chmod 600 $TEMPDIR/home/pi/.ssh/authorized_keys
chown 1000:1000 $TEMPDIR/home/pi/.ssh/authorized_keys


echo "Cleaning..."

umount $TEMPDIR/boot
umount $TEMPDIR
echo "Loop devices unmounted"

kpartx -d raspbian.img
rmdir $TEMPDIR
echo "All cleaned !"
