# How to build an app

go to the `contiki` folder of your app.

do `make TARGET=srf06-cc26xx BOARD=cc2650/sensortag all`, it will produce a `.bin` file.

# How to flash

## plug the debuger

Images soon

It's a bit hard to separate the two devices so be cool with them :).

## use uniflash

if you are in the youpi-6lowpan-vm: use the `uniflash` command to start uniflash. In the `choose your Device` part, type `CC2650F128` then click on the `start` button. You can choose the `.bin` file to flash and click on `Load Image` to flash.

