# Client app on the computer

* `coap_get_stat.py`
* `coap_client_get_post.py`

the first application get (via coap) several resources and then, when killed, it displays some statistics.

the second application get (via coap) a ressource and, if the value of the ressource is high enough, it post (via coap) to toggle the light on the device.
