# dongle configuration:

CC2531 with sensniff : [contiki repo](https://github.com/contiki-os/contiki/examples/sensniff)

put `DEFINES+=MODELS_CONF_CC2531_USB_STICK=1` in the `Makefile`

`make TARGET=cc2530dk all`

# how to use sensniff to get .pcap file:

need `pyserial` and a device flashed with sensniff (from contiki-os)

`sudo python2.7 sensniff -d /dev/ttyACM0 -p name_of_pcap_file.pcap`

maybe your device is on serial port `/dev/ttyACMX`

## wireshark configuration:

* Edit -> Prefereces -> Protocols -> IEEE 802.15.4
   * select 'TI CC24xx FCS format'

* Edit -> Preferences -> Protocols -> 6lowpan
   * contexts (aaaa:: ou f0::)

* add pipe
  * Capture -> Option
  * `Manage interfacess...`
  * `Pipes`
  * `+` put `/tmp/sensniff` `enter`
  * `Ok`
  * `close`

* Capture pipe `/tmp/sensniff`
