"""
TODO: make a docopt interface

This script is inspired by the uart_collector script of this 
projet https://github.com/alcir/microbit-ble
"""
import time
from bluepy import btle
import bluetooth

# server6lbr = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
# server6lbr.connect(('B8:27:EB:36:1B:9D', 3))

# Intiate a connection to the RPi using a
# ble socket with the pybluez library
def connectRPiServer(address, port):
    conn = bluetooth.BluetoothSocket(bluetooth.RFCOMM)
    try:
        conn.connect((address, port))
    except bluetooth.BluetoothError as be:
        print("An unexpected error occured: " +  be)
        conn = None
        
    return conn

# Handle the notification received by the client from a
# ble device. 
class MyDelegate(btle.DefaultDelegate):
    def __init__(self, microbit, server6lbr):
        self.serverMicroBit = microbit
        self.server6lbr = server6lbr
        btle.DefaultDelegate.__init__(self)

    def handleNotification(self, cHandle, data):
        self.server6lbr.send(data)
        dataToMicrobit = self.server6lbr.recv(1024)

        if dataToMicrobit:
            print("Data received: " + str(dataToMicrobit))
            self.serverMicroBit.write(dataToMicrobit)
        

class controllerBLE():
    def __init__(self, device_name, device_mac, server, sampling_interval_sec=1, retry_interval_sec=5):
        # Prepare the config to connect to the MicroBit device
        self.conn = None
        self.server6lbr = server
        self.device_name = device_name
        self.device_mac = device_mac
        self._sampling_interval_sec = sampling_interval_sec
        self._retry_interval_sec = retry_interval_sec
        # Connects with re-try mechanism
        self._re_connect()

    def _connect(self):
        print("Connecting...")
        self.conn = btle.Peripheral(self.device_mac, btle.ADDR_TYPE_RANDOM)
        #self.conn.setSecurityLevel("medium")
        print("Connected...")
        self._enable()

    def _enable(self):
        self.svc = self.conn.getServiceByUUID("6e400001-b5a3-f393-e0a9-e50e24dcca9e")
        self.ch = self.svc.getCharacteristics("6e400002-b5a3-f393-e0a9-e50e24dcca9e")[0]
        self.chwrite = self.svc.getCharacteristics("6e400003-b5a3-f393-e0a9-e50e24dcca9e")[0]

        # Write 0200 to CCCD UUID
        # Impportant to reply to the microbit
        self.ch_cccd = self.ch.getDescriptors("00002902-0000-1000-8000-00805f9b34fb")[0]
        self.ch_cccd.write(b"\x02\x00", True)

        self.conn.setDelegate(MyDelegate(self.chwrite, self.server6lbr))
        time.sleep(1)
        print("UART notification enabled...")

    def run(self):
        # while True:
        while True:
            try:
                if self.conn.waitForNotifications(3.0):
                    continue

                # Idle state where no requests are sent by the microbit 
                
            except Exception as e:
                print('An unexpected error occured: ' + str(e))
                self.conn.disconnect()
                break

        # time.sleep(self._retry_interval_sec)
        # self._re_connect()

    def _re_connect(self):
        while True:
            try:
                self._connect()
                break
            except Exception as e:
                print(str(e))
                time.sleep(self._retry_interval_sec)


def main():
    server6lbr = connectRPiServer(address='B8:27:EB:36:1B:9D', port=3)
    
    if server6lbr is None:
        exit(1)
    
    mbc = controllerBLE(device_name="microbit", device_mac="E0:14:9E:14:11:72", server=server6lbr, sampling_interval_sec=1)
    mbc.run()
    
    while True:
        time.sleep(1000)
        pass
    
if __name__ == '__main__':
    main()