# Comments for deployment

## Linux Users

**Requirements:** kpartx, unzip, a wifi-hotspot

**Simply run:**

* `1-getimage.sh` to get the Raspbian freshest image
* `2-customize.sh` to initialize the image with some Youpi's configuration
You can change the password sha via `openssl passwd -1 -salt xyz  yourpass` and the wifi configuration under `wifi conf`.
* `3-flashgordon.sh` to flash a micro SD card mounted on `/dev/mapper/mmcblk0`



## OSX Users

**Requirements:** linux host (like Khamul) with sudoer rights

**Such as Linux users:**
* Steps 1 & 2 : Go through Khamul or a RPi, since your fucky OS doesn't support EXT2FS.
* Steps 3 :
  * Get the name of the SD card's device :

    `diskutil list`

  * Make dd with 1m as block size and don't forget to use RAW disks instead of disks, like :

    `sudo dd bs=1m if=raspbian.img of=/dev/rdisk<disk# from diskutil> conv=sync`


## Windows Users

*You're fired.*

# Install 6lbr on the raspi

## config 6lbr

log on the pi via the hotspot (you should know password and ip if you set them)

Then, just follow thoses steps to finalize the install and the configuration of the 6lbr.

* ` sudo apt update && sudo apt upgrade `
* ` sudo apt-get install libncurses5-dev bridge-utils `
* ` sudo sed -i '1s/^/dwc_otg.speed=1 /' /boot/cmdline.txt `

* Go to `~/6lbr/examples/6lbr/`
  * ` make all plugins tools `
  * go grab a coffe it may be a bit long...
  * ` sudo make install `

* Configuration in ` /etc/6lbr/6lbr.conf `:
```
MODE=ROUTER

RAW_ETH=0
BRIDGE=1
CREATE_BRIDGE=0
DEV_BRIDGE=br0
DEV_TAP=tap0
DEV_ETH=eth0
RAW_ETH_FCS=0

DEV_RADIO=/dev/ttyACM0
BAUDRATE=115200

LOG_LEVEL=3
```

* ` sudo /usr/lib/6lbr/bin/nvm_tool --update --channel 25 /etc/6lbr/nvm.dat ` (Not tested with other channel but should work too)
* add two lines in `/etc/sysctl.conf`:
```
net.ipv4.ip_forward = 1
net.ipv6.conf.all.forwarding=1
```

* Configuration of the bridge in ` /etc/network/interfaces.d/eth0 `:
```
auto eth0
allow-hotplug eth0
iface eth0 inet static
address 0.0.0.0

auto br0
iface br0 inet dhcp
bridge_ports eth0
bridge_stp off
up echo 0 > /sys/devices/virtual/net/br0/bridge/multicast_snooping
post-up ip link set br0 address 'ip link show eth0 | grep ether | awk '{print $2}''
```

* ` sudo systemctl enable 6lbr ` <- important
* ` sudo service 6lbr start `

## slip-radio on cc2531

* in the vagrant VM:
  * `cd ~/contiki-oikonomou/examples/cc2530dk/cc2531-slip-radio/`
  * `make all`
  * plug the debuger and the cc2531 together and to the computer
  * `cd ~/cc-tool/`
  * `./cc-tool -e -w ~/contiki-oikonomou/examples/cc2530dk/cc2531-slip-radio/cc2531-slip-radio.hex`
  * info [here](../docs/cc2531)

* not in the VM:
  * you should install the VM
  * check thoses 2 repos :
    * to compile cc2531-slip-radio : `https://github.com/g-oikonomou/contiki` branch `cc/slip-radio`
    * to flash : `https://github.com/dashesy/cc-tool.git``


## More configuration:

When evrithing is working, you may need to activate all the rpl configuration in the `configuration → RPl` on the web interface. It is just a way to be sure that RPL is activated.
