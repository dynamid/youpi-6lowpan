# How to build an app

go to the `contiki` folder of your app.

do `make TARGET=srf06-cc26xx BOARDS=cc2650/sensortag all`, it will produce a `.bin` file.

# How to flash

## plug the debuger

Images soon

It's a bit hard to separate the two devices so be cool with them :).

## install uniflash

* `wget http://software-dl.ti.com/ccs/esd/uniflash/uniflash_sl.5.0.0.2289.run`
* install `libgconf-2-4` (pacman user : `gconf`)
* `chmod +x uniflash_sl.5.0.0.2289.run`
* `./uniflash_sl.5.0.0.2289.run`

## run and use uniflash

* `~/ti/uniflash_5.0.0/node-webkit/nw`
* `choose your Device` : `CC2650F128`
* scroll down, and `Start`
* choose the `.bin` file
* connect the debuger and the cc2650
* click on `Load Image` to flash

