# Client app on the computer:

* `coap_get_stat.py`
* `coap_client_get_post.py`

# requirement:

* python3
* aiocoap package
* numpy package
* matplotlib package

# dongle configuration:

CC2650 with the contiki-web-demo : `contiki/examples/cc26xx/cc26xx-web-demo/`.

See configuration files in the docs/cc2650 part of this repository.

`make TARGET=srf06-cc26xx BOARD=sensortag/cc2650 all`

# `coap_get_stats.py`:

this application get (via coap) several resources and then, when killed, displays some statistics.

# `coap_client_get_post.py`:

this application get (via coap) a ressource and, if the value of the ressource is high enough, it post (via coap) to toggle the light on the same device.
