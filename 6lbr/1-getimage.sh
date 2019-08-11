#!/bin/bash

#Je ne sais pas si c'est la bonne vesion : il faudrait que je reinstale un raspi avec cette distro light pour être certain

wget https://downloads.raspberrypi.org/raspbian/images/raspbian-2019-04-09/2019-04-08-raspbian-stretch.zip -O raspbian.zip
unzip raspbian.zip
# On supprime le zip pour gagner un peu de place puisqu'il ne sert plus à rien
rm raspbian.zip
mv *.img raspbian.img
