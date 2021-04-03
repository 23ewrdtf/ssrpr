#!/bin/bash

echo "┌─────────────────────────────────────────"
echo "|This script will install SSRPRADIO."
echo "|After reboot it should play your YT playlist automatically."
echo "└─────────────────────────────────────────"
read -p "Press enter to continue"

echo "┌─────────────────────────────────────────"
echo "|Updating repositories"
echo "└─────────────────────────────────────────"
sudo apt-get update

echo "┌─────────────────────────────────────────"
echo "|Installing pulseaudio"
echo "└─────────────────────────────────────────"
sudo apt-get install pulseaudio -yqq

echo "┌─────────────────────────────────────────"
echo "|Installing Tizonia"
echo "└─────────────────────────────────────────"
curl -kL https://goo.gl/Vu8qGR | bash

echo "┌─────────────────────────────────────────"
echo "|Configuring tizonia"
echo "└─────────────────────────────────────────"
sudo wget -q https://raw.githubusercontent.com/tretos53/ssrpr/main/tizonia.conf -O /etc/xdg/tizonia/tizonia.conf
wget -q https://raw.githubusercontent.com/tretos53/ssrpr/main/boottizonia.sh -O /home/pi/boottizonia.sh
sed -i -- "s#PLAYLIST#${1}#g" /home/pi/boottizonia.sh
sudo echo "bash /home/pi/boottizonia.sh" >> /home/pi/.bashrc

echo "┌─────────────────────────────────────────"
echo "|Configuring Alsa"
echo "└─────────────────────────────────────────"
sudo sed -i -- "s/defaults.ctl.card 0/defaults.ctl.card 1/g" /usr/share/alsa/alsa.conf
sudo sed -i -- "s/defaults.pcm.card 0/defaults.pcm.card 1/g" /usr/share/alsa/alsa.conf

echo "┌─────────────────────────────────────────"
echo "|Installing espeak"
echo "└─────────────────────────────────────────"
sudo apt-get install espeak -yq

echo "┌─────────────────────────────────────────"
echo "|Please reboot your pi and test."
echo "└─────────────────────────────────────────"
