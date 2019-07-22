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
