"""Server

A ble server that gets commands from ble device and forward requests in a 6lowpan 
network to finally send back the response  

Usage: 
    server.py --host <ble-mac> [--port <port>] [--debug]

Options: 
    -h, --help            Show this help menu.
    -d, --debug           Active the debug mode [default: False]
    -H, --host <ble-mac>  The BLE MAC address of the server.
    -p, --port <port>     The port use in the ble connection. [default: 3]

"""

import bluetooth
from aiocoap import *
import asyncio
from docopt import docopt, DocoptExit
import logging

# hostMACAddress = 'B8:27:EB:8C:B2:4F'
# port = 3

# backlog = 1
# size = 1024
# addr='[fd00::212:4b00:1204:cb03]' 
# CoAPport='5683'
# f='sen/bar/temp

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
    args = docopt(__doc__)
    logging.info("Start the server")
    hostMACAddress = args["--host"]
    port = int(args["--port"])

    logging.basicConfig(
        level=logging.DEBUG if verbose else logging.INFO,
        format="%(levelname)s:%(message)s"
    )

    backlog = 1
    size = 1024
    addr='[fd00::212:4b00:1204:cb03]' 
    CoAPport='5683'
    f='sen/bar/temp'
    
    s = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    s.bind((hostMACAddress, port))
    s.listen(backlog)
    client = None
    logging.info("Waiting a client connection")
    while True:
        try:
            client, clientInfo = s.accept()
            logging.info("Client connected")
            while 1:
                data = client.recv(size)
                if data:
                    data = data.decode("utf-8")
                    logging.debug('Received data from the controller: ' + data)
                    if 'get' in data:
                        logging.debug("CoAP get command sent")
                        uri = 'coap://'+addr+':'+CoAPport+'/'+f
                        raw_res = asyncio.get_event_loop().run_until_complete(getCoAP(uri)).decode("utf-8")
                        res = str(raw_res) + ','
                        client.send(res) # Echo back to client
                        logging.debug('Data send back to the controller: ' + res)

        except KeyboardInterrupt:
            logging.info("Killing process in progress")
            if client is not None:
                client.send(b'Deconnection')
                client.close()
            s.close()
            break
        else:	
            logging.error("Client deconnected\nWaiting for another client")
            client.close()

        
            
if __name__ == '__main__':
    try:
        docopt(__doc__)
    except DocoptExit:
        print(__doc__)
    else:
        main()
    main()
