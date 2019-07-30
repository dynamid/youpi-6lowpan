# dongle configuration:

CC2531 with sensniff : `contiki/example/sensniff`

put `DEFINES+=MODELS_CONF_CC2531_USB_STICK=1` in the `Makefile`

`make TARGET=cc2530dk all`

# how to use sensniff to get .pcap file:

need `pyserial` and a device flashed with sensniff (from contiki-os)

`python2.7 sensniff -d /dev/ttyACM0 -p name_of_pcap_file.pcap`

maybe your device is on serial port `/dev/ttyACMX`

## wireshark configuration:

* Protocols -> IEEE 802.15.4
   * select 'TI CC24xx FCS format'

* contexts (aaaa:: ou f0::)
