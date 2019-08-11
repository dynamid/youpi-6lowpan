# SDK for the YOUPI-6LowPAN platform

This vagrant setups a VM to develop and flash contiki on CC2531 and CC2650

* login: `vagrant`
* passw: `vagrant`

# requirement

* `vagrant`
* `virtualbox` and `virtualbox-guest-utils`, `virtualbox-guest-module-arch` (because I am using arch)
* allow VB to use USB: `sudo usermod -a -G vboxusers YOUR_USER_NAME`

# Content

* contiki
* contiki-oikonomou | fork to compile `cc2531 slip-radio`
* cc2531 tool-chain | sdcc
* cc2650 tool-chain
* cc-tool           | to flash cc2531
* uniflash          | to flash cc2650
* firefox+Copper    | Coap tool → you may need to link the eth of the host and the VM to use it (IDK how...)
* mosquitto         | MQTT tool
* this repo
