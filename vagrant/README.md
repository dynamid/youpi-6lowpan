# SDK for the YOUPI-6LowPAN platform

# requirement

* `vagrant`
* `virtualbox` and `virtualbox-guest-utils`, `virtualbox-guest-module-arch` (because I am using arch)
* allow VB to use USB: `sudo usermod -a -G vboxusers YOUR_USER_NAME`
* create a folder next to the `Vagrantfile` named `sync-folder` : `mkdir sync-folder`

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
* firefox+Copper    | Coap tool → you may need to link the eth of the host and the VM to use it (IDK how...)
* mosquitto         | MQTT tool
* this repo

# Make firefox & Copper working

* run it with the command `firefoxCopper`

Before you can use them : you need to **restart firefox**. So first time you start it it will NOT work, just restart and it is ok (firefox configure the app when it start)

# Make uniflash working

uniflash is not working on the VM. You should install it and flash from the host. You can use the `~/synced-folder` to move `.hex` file from the VM to the host.

You can find how to install and use it in the [CC2650 documentation](../docs/CC2650)
