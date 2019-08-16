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

* ` sudo ./create6lbr.sh `

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
