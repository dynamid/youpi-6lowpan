#!/bin/bash

#Je ne sais pas si c'est la bonne vesion : il faudrait que je reinstale un raspi avec cette distro light pour être certain

wget https://downloads.raspberrypi.org/raspbian_lite_latest -O raspbian.zip
unzip raspbian.zip
# On supprime le zip pour gagner un peu de place puisqu'il ne sert plus à rien
rm raspbian.zip
mv *.img raspbian.img
