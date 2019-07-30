import logging
import asyncio
import time
import matplotlib.pyplot as plt
import numpy as np
import sys

from aiocoap import *

logging.basicConfig(level=logging.INFO)

addr='[fd00::212:4b00:1204:cb03]' #'134.102.218.18' #coap.me #'localhost'
port='5683'
file=['sen/bar/temp', 'sen/hdc/t']
clock=1 #min 5 sec


async def get(uri):
    protocol = await Context.create_client_context()
    request = Message(code=GET, uri=uri)
    response = await protocol.request(request).response
    return response.payload

#######################################

list_values  = [ [] for _ in file]
end = False
print("recuperation des infos sur :")
for f in file: print('coap://'+addr+':'+port+'/'+f)

k=0
while not end:
    print("\rget "+str(k), end='')
    k+=1
    for i,f in enumerate(file):
        try:
            uri = 'coap://'+addr+':'+port+'/'+f
            raw_res = asyncio.get_event_loop().run_until_complete(get(uri)).decode("utf-8")
            #print(raw_res)
            res = float(raw_res)
            list_values[i].append( res )

        except KeyboardInterrupt:
            end = True
    try:
        if not end:
            time.sleep(clock)
    except:
        end = True

print("fin de recuperation")

print(list_values)

means = [np.mean(vs) for vs in list_values]

for i in range(len(list_values)):
    plt.plot(list_values[i], 'o-', label=file[i])
    plt.plot(np.ones(len(list_values[i]))*means[i], 'o', label='mean '+file[i])

plt.legend(bbox_to_anchor=(0., 1.02, 1., .102), loc=3,
           ncol=2, mode="expand", borderaxespad=0.)
plt.show()
