#A simple Python script to receive messages from a client over
#Bluetooth using PyBluez (with Python 2).

import bluetooth
from aiocoap import *
import asyncio

hostMACAddress = 'B8:27:EB:36:1B:9D'
port = 3
backlog = 1
size = 1024
addr='[fd00::212:4b00:1204:cb03]' 
CoAPport='5683'
f='sen/bar/temp'

async def getCoAP(uri):
    protocol = await Context.create_client_context()
    request = Message(code=GET, uri=uri)
    response = await protocol.request(request).response
    return response.payload

async def post(uri, payload):
    protocol = await Context.create_client_context()
    print(uri, payload)
    request = Message(code=POST, payload=payload, uri=uri)
    response = await protocol.request(request).response

def main():
    print("Start the server")
    s = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    s.bind((hostMACAddress, port))
    s.listen(backlog)
    print("Waiting a client connection")
    try:
        client, clientInfo = s.accept()
        print("Client connected")
        while 1:
            data = client.recv(size)
            if data:
                data = data.decode("utf-8")
                print(f'Received data from the controller: {data}')
                if 'get' in data:
                    print("CoAP get command sent")
                    uri = 'coap://'+addr+':'+CoAPport+'/'+f
                    raw_res = asyncio.get_event_loop().run_until_complete(getCoAP(uri)).decode("utf-8")
                    res = str(raw_res)
                    client.send(f"{res},") # Echo back to client
                    print(f'Data send back to the controller: {res}')
    except:	
        print("Closing socket")
        client.close()
        s.close()

if __name__ == '__main__':
    main()
