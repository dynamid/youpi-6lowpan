# goal: youpi-6lowpan
6LowPAN deployment on the YOUPI platform

## BUT
You can use this repo to build a little network using Coap communication over 6lowpan via contiki


# Install 6lbr on raspy
6lbr with CC2531 flashed with `slip-radio` from a fork of contiki. _I dont realy understand the youpi files : it's up to you_

# Install youpi-6lowpan-VM via vagrant
Require `vagrant` over VirtualBox.

Int the `vagrant` folder type `vagrant up` to generate a VM with compilation chain and tool already installed.

# Apps
This repo provide some apps in the `apps` folder
* `coap-client-python` : comunication beetween python and cc2650 via Coap over 6lowpan, using 6lbr
* `sensniff` : generation of `.pcap` files with cc2531 dongle sniff
* `cc26xx-web-client-demo-server-client` : a manual fork of the contiki `cc26xx-web-client-demo` with Coap client.

# Specific docs
* doc for cc2650 flash and compilation
* doc for cc2531 flash and compilation
