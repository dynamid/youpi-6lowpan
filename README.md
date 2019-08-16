# goal: youpi-6lowpan
6LowPAN deployment on the YOUPI platform

## Purpose
You can use this repo to build a little network using Coap communication over 6lowpan via contiki

# 1: Install youpi-6lowpan-VM via vagrant
Require `vagrant` over VirtualBox.

Int the [vagrant](vagrant/) folder type `vagrant up` to generate a VM with compilation chain and tool already installed.

# 2: Install 6lbr on raspy
[6lbr](6lbr/) with CC2531 flashed with `slip-radio` from a fork of contiki.

# 3: Apps
This repo provide some apps in the `apps` folder
* [coap-client-python](apps/coap-client-python/) : comunication beetween python and cc2650 via Coap over 6lowpan, using 6lbr
* [sensniff](apps/sensniff/) : generation of `.pcap` files with cc2531 dongle sniff
* [cc26xx-web-client-demo-server-client](apps/coap-client-cc2650) : a manual fork of the contiki `cc26xx-web-client-demo` with Coap client.

# Specific docs
* doc for [cc2650](docs/cc2650) flash and compilation
* doc for [cc2531](docs/cc2531) flash and compilation

#Troubleshooting

* If the bbbb:: ipv6 did not appear : reset the connection and reboot the raspi. If you are on the youpi-6lowpan-VM : restart the Host connection.
