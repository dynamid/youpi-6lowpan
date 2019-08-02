# Comments for deployment

## Linux Users

**Requirements:** kpartx, unzip

**Simply run:**

* ```1-getimage.sh``` to get the Raspbian freshest image
* ```2-customize.sh``` to initialize the image with some Youpi's configuration
* ```3-flashgordon.sh``` to flash a micro SD card mounted on ```/dev/mapper/mmcblk0```



## OSX Users

**Requirements:** linux host (like Khamul) with sudoer rights

**Such as Linux users:**
* Steps 1 & 2 : Go through Khamul or a RPi, since your fucky OS doesn't support EXT2FS.
* Steps 3 :
  * Get the name of the SD card's device :

    ```diskutil list```

  * Make dd with 1m as block size and don't forget to use RAW disks instead of disks, like :

    ```sudo dd bs=1m if=raspbian.img of=/dev/rdisk<disk# from diskutil> conv=sync```


## Windows Users

*You're fired.*

# Install 6lbr on the raspi

## config 6lbr

* ``` sudo apt update && sudo apt upgrade ```
* ``` sudo apt-get install libncurses5-dev bridge-utils ```
* ``` sed -i '1s/^/dwc_otg.speed=1/' /boot/cmdline.txt ```

* Go to ```contiki/examples/6lbr/```
  * ``` make all pluguins tools ```
  * ``` sudo make install ```

* Configuration in ``` /etc/6lbr/6lbr.conf ``` :
```
MODE=ROUTER
RAW_ETH=1
BRIDGE=0
DEV_BRIDGE=br0
DEV_TAP=tap0
DEV_ETH=eth0
RAW_ETH_FCS=0
DEV_RADIO=/dev/ttyACM0
BAUDRATE=115200
LOG_LEVEL=3
```

* ``` sudo /usr/lib/6lbr/bin/nvm_tool --update --channel 25 /etc/6lbr/nvm.dat ```
* ``` sudo service 6lbr start ```

## slip-radio on cc2531

see the `doc/cc2531` to compile and flash the cc2531 with `contiki-oikonomou/examples/cc2530dk/cc2531-slip-radio`(repo : `https://github.com/g-oikonomou/contiki` branch `cc/slip-radio`). If not working, i put the slip-radio file `.hex` in the repo.
