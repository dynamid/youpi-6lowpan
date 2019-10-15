# Install missing packages
sudo apt install  bluetooth libbluetooth-dev
sudo apt install bluez minicom

# Get the library
sudo pip3 install pybluez bluepy

# Mac addresses are relative to the devices
# Server : B8:27:EB:8C:B2:4F
# Client : B8:27:EB:36:1B:9D

# We need to make the two rpi discoverable 
sudo hciconfig hci0 piscan 
