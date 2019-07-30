#include "contiki.h"
#include "contiki-net.h"
#include "er-coap-engine.h"
#include "cc26xx-web-demo.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define SERVER_NODE(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1665, 0x2707)
#define ACTOR_NODE(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1204, 0xc92d)
#define LOCAL_PORT		UIP_HTONS(COAP_DEFAULT_PORT + 1)
#define REMOTE_PORT		UIP_HTONS(COAP_DEFAULT_PORT)
#define TIME_INTERVAL		5

PROCESS(coap_client_process, "Erbium Client");

uip_ipaddr_t server_ipaddr;
uip_ipaddr_t actor_ipaddr;
static struct etimer et;
static bool toggle = false;
static bool is_on = false;

///////////////////////////////////////////////////
void client_chunk_handler_get(void *response)
{
  const uint8_t *chunk;

  coap_get_payload(response, &chunk);

  int value = atoi((char*)chunk);

  if((value>100 && !is_on) || (value <=100 && is_on)){
  	toggle = true;
  	is_on = !is_on;
  }
}
void client_chunk_handler_post(void *response)
{
  const uint8_t *chunk;

  /*int len = */coap_get_payload(response, &chunk);

}


////////////////////////////////////////////////////
PROCESS_THREAD(coap_client_process, ev, data)
{
  PROCESS_BEGIN();

  static coap_packet_t request[1];

  SERVER_NODE(&server_ipaddr);
  ACTOR_NODE(&actor_ipaddr);

//receives all COAP messages
  coap_init_engine();

  etimer_set(&et, TIME_INTERVAL * CLOCK_SECOND);

  while(1){
    PROCESS_YIELD();

    //get value
    if(etimer_expired(&et)); {

      coap_init_message(request, COAP_TYPE_CON, COAP_GET, 0);
      coap_set_header_uri_path(request, "/sen/opt/light");

      COAP_BLOCKING_REQUEST(&server_ipaddr, REMOTE_PORT, request, client_chunk_handler_get);

      etimer_reset(&et);
    }

    //do omething
    if(toggle){
      coap_init_message(request, COAP_TYPE_CON, COAP_POST, 0);
      coap_set_header_uri_path(request, "/lt/r");

      const char msg[] = "toggle_light";
      coap_set_payload(request, (uint8_t *)msg, sizeof(msg)-1);

      COAP_BLOCKING_REQUEST(&actor_ipaddr, REMOTE_PORT, request, client_chunk_handler_post);
    
      toggle = false;
    }


  }

  PROCESS_END();
}
