#include "contiki.h"
#include "contiki-net.h"
#include "er-coap-engine.h"
#include "cc26xx-web-demo.h"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>


#define SERVER_NODE1(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1665, 0x2707)
#define SERVER_NODE2(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1665, 0x2707)
#define ACTOR_NODE1(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1204, 0xc92d)
#define ACTOR_NODE2(ipaddr) 	uip_ip6addr(ipaddr, 0xfd00, 0, 0, 0, 0x212, 0x4b00, 0x1204, 0xc92d)
#define LOCAL_PORT		UIP_HTONS(COAP_DEFAULT_PORT + 1)
#define REMOTE_PORT		UIP_HTONS(COAP_DEFAULT_PORT)
#define TIME_INTERVAL		5

PROCESS(coap_client_process, "Erbium Client");

static struct etimer et;
uip_ipaddr_t server_ipaddr1;
uip_ipaddr_t actor_ipaddr1;
static bool toggle1 = false;
static bool is_on1 = false;
uip_ipaddr_t server_ipaddr2;
uip_ipaddr_t actor_ipaddr2;
static bool toggle2 = false;
static bool is_on2 = false;

///////////////////////////////////////////////////
void client_chunk_handler_get1(void *response)
{
  const uint8_t *chunk;

  coap_get_payload(response, &chunk);

  int value = atoi((char*)chunk);

  if((value>100 && !is_on1) || (value <=100 && is_on1)){
  	toggle1 = true;
  	is_on1 = !is_on1;
  }
}
void client_chunk_handler_get2(void *response)
{
  const uint8_t *chunk;

  coap_get_payload(response, &chunk);

  int value = atoi((char*)chunk);

  if((value>100 && !is_on2) || (value <=100 && is_on2)){
  	toggle2 = true;
  	is_on2 = !is_on2;
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

  SERVER_NODE1(&server_ipaddr1);
  ACTOR_NODE1(&actor_ipaddr1);
  SERVER_NODE2(&server_ipaddr2);
  ACTOR_NODE2(&actor_ipaddr2);

//receives all COAP messages
  coap_init_engine();

  etimer_set(&et, TIME_INTERVAL * CLOCK_SECOND);

  while(1){
    PROCESS_YIELD();

    //get value
    if(etimer_expired(&et)); {

      coap_init_message(request, COAP_TYPE_CON, COAP_GET, 0);
      coap_set_header_uri_path(request, "/sen/opt/light");

      COAP_BLOCKING_REQUEST(&server_ipaddr1, REMOTE_PORT, request, client_chunk_handler_get1);

      coap_init_message(request, COAP_TYPE_CON, COAP_GET, 0);
      coap_set_header_uri_path(request, "/sen/opt/light");

      COAP_BLOCKING_REQUEST(&server_ipaddr2, REMOTE_PORT, request, client_chunk_handler_get2);

      etimer_reset(&et);
    }

    //do omething
    if(toggle1){
      coap_init_message(request, COAP_TYPE_CON, COAP_POST, 0);
      coap_set_header_uri_path(request, "/lt/r");

      const char msg[] = "toggle1_light";
      coap_set_payload(request, (uint8_t *)msg, sizeof(msg)-1);

      COAP_BLOCKING_REQUEST(&actor_ipaddr1, REMOTE_PORT, request, client_chunk_handler_post);

      toggle1 = false;
    }
    if(toggle2){
      coap_init_message(request, COAP_TYPE_CON, COAP_POST, 0);
      coap_set_header_uri_path(request, "/lt/r");

      const char msg[] = "toggle2_light";
      coap_set_payload(request, (uint8_t *)msg, sizeof(msg)-1);

      COAP_BLOCKING_REQUEST(&actor_ipaddr2, REMOTE_PORT, request, client_chunk_handler_post);

      toggle2 = false;
    }


  }

  PROCESS_END();
}
