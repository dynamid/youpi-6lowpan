# Server - Client - Actor application

the topology:

![Topology](../../other/imgs/topo.jpg)


# dongle configuration:

* 2 CC2650 with the contiki-web-demo : [contiki repo](https://github.com/contiki-os/contiki/examples/cc26xx/cc26xx-web-demo/).

See configuration files in the docs/cc2650 part of this repository.

`make TARGET=srf06-cc26xx BOARD=sensortag/cc2650 all`

* 1 CC2650 with the contiki-web-demo-server-client : _here_

`make TARGET=srf06-cc26xx BOARD=sensortag/cc2650 all`
