#!/bin/bash

if [ "$EUID" -ne 0 ]
	then echo "Must be root, run sudo -i before running this script."
	exit
fi

echo "┌─────────────────────────────────────────"
echo "|This script will install SSRPRADIO."
echo "|After reboot it should play your YT playlist automatically."
echo "└─────────────────────────────────────────"
read -p "Press enter to continue"

echo "┌─────────────────────────────────────────"
echo "|Updating repositories"
echo "└─────────────────────────────────────────"
apt-get update -yqq

echo "┌─────────────────────────────────────────"
echo "|Installing pulseaudio"
echo "└─────────────────────────────────────────"
apt-get install pulseaudio -yqq

echo "┌─────────────────────────────────────────"
echo "|Installing Tizonia"
echo "└─────────────────────────────────────────"
curl -kL https://goo.gl/Vu8qGR | bash

echo "┌─────────────────────────────────────────"
echo "|Configuring tizonia"
echo "└─────────────────────────────────────────"
sed '/OMX.Aratelia.audio_renderer.alsa.pcm.preannouncements_disabled.port0/d' /etc/xdg/tizonia/tizonia.conf
sed '/OMX.Aratelia.audio_renderer.alsa.pcm.alsa_device/d' /etc/xdg/tizonia/tizonia.conf
sed '/OMX.Aratelia.audio_renderer.alsa.pcm.alsa_mixer.port0/d' /etc/xdg/tizonia/tizonia.conf

sed -i '/OMX.Aratelia.audio_renderer.pulseaudio.pcm.preannouncements_disabled.port0 = false/s/^#//g' /etc/xdg/tizonia/tizonia.conf
sed -i '/OMX.Aratelia.audio_renderer.pulseaudio.pcm.default_volume = Value from 0/s/^#//g' /etc/xdg/tizonia/tizonia.conf

wget -q https://raw.githubusercontent.com/tretos53/ssrpr/main/boottizonia.sh -O /home/pi/boottizonia.sh
sed -i -- "s/PLAYLIST/${1}/g" /home/pi/boottizonia.sh
echo "bash /home/pi/boottizonia.sh" >> /home/pi/.bashrc

echo "┌─────────────────────────────────────────"
echo "|Configuring Alsa"
echo "└─────────────────────────────────────────"
sed -i -- "s/defaults.ctl.card 0/defaults.ctl.card 1/g" /usr/share/alsa/alsa.conf
sed -i -- "s/defaults.pcm.card 0/defaults.pcm.card 1/g" /usr/share/alsa/alsa.conf

echo "┌─────────────────────────────────────────"
echo "|Please reboot your pi and test."
echo "└─────────────────────────────────────────"
