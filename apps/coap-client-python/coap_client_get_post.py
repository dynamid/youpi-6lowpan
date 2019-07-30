import logging
import asyncio
import time

import numpy as np
import sys

from aiocoap import *

logging.basicConfig(level=logging.INFO)

addr='[fd00::212:4b00:1204:cb03]' #'134.102.218.18' #coap.me #'localhost'
port='5683'
geter='sen/opt/light'
poster='lt/g'
clock=1 #min 5 sec


async def get(uri):
    protocol = await Context.create_client_context()
    request = Message(code=GET, uri=uri)
    response = await protocol.request(request).response
    return response.payload

async def post(uri, payload):
    protocol = await Context.create_client_context()

    print(uri, payload)

    request = Message(code=POST, payload=payload, uri=uri)
    response = await protocol.request(request).response
    #print(response)


end = False
green_limit = 200
red_limit = 100
green_on = False
red_on = False
k = 0
while not end:
    try:
        k+=1
        uri_get = 'coap://'+addr+':'+port+'/'+geter
        uri_post= 'coap://'+addr+':'+port+'/'+poster
        raw_res = asyncio.get_event_loop().run_until_complete(get(uri_get)).decode("utf-8")
        #print(raw_res)
        res = float(raw_res)
        #if k%20==0: print(res)

        if res > green_limit and not green_on :
            asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/g', b"on"))
            green_on = True
        if res <= green_limit and green_on:
            asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/g', b"off"))
            green_on = False

        if res > red_limit and not red_on :
            asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/r', b"on"))
            red_on = True
        if res <= red_limit and red_on:
            asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/r', b"off"))
            red_on = False

    except KeyboardInterrupt:
        end = True

if green_on:
	asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/g', b"off"))
if red_on:
	asyncio.get_event_loop().run_until_complete(post('coap://'+addr+':'+port+'/lt/r', b"off"))
