# SDK for the YOUPI-6LowPAN platform

# requirement

* `vagrant`
* `virtualbox` and `virtualbox-guest-utils`, `virtualbox-guest-module-arch` (because I am using arch)
* allow VB to use USB: `sudo usermod -a -G vboxusers YOUR_USER_NAME`

# How to start

* do `vagrant up` in the `vagrant` folder
* enter `1` for your ethernet interface (it can be an other number, select your ethernet interface)
* grab a coffe : it is realy long
* login: `vagrant`
* passw: `vagrant`

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
