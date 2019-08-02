# How to build an app

go to the `contiki` folder of your app.

add `DEFINES+=MODELS_CONF_CC2531_USB_STICK=1` to the `Makefile`

do `make TARGET=cc2530dk all`, it will produce a `.hex` file.

# How to flash

## plug the debuger

Images soon

if the led is red: press the reset button.

https://www.zigbee2mqtt.io/getting_started/flashing_the_cc2531.html

## use cc-tool

locate the cc-tool folder if you are in the youpi-6lowpan-VM (~/cc-tool) or see https://github.com/dashesy/cc-tool (and `make` it [see the `vagrant/script.sh`_Outil de flash CC2531_ part] )

to flash: `./cc-tool -e -w path/to/file.hex`
