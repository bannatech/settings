#!/bin/sh
backup="sda/Wyatt/$(date +%Y_%m_%d_%T)/"
tar cvJf /boot.txz /boot/
tar cvJf /etc.txz --exclude /etc/dolphin-iso /etc/
tar cvJf /var.txz --exclude /var/cache --exclude /var/lib /var/
tar cvJf /share.txz /shared/
tar cvJf /home.txz --exclude /home/aftix/torrent --exclude /home/aftix/.local/share/Steam /home/
tar cvJf /root.txz /root/
ftp -n <<EOF
open 192.168.0.1
user anonymous aaaa
quote mkdir $backup
quote cd $backup
put /boot.txz
put /etc.txz
put /var.txz
put /share.txz
put /home.txz
put /root.txz
EOF
rm /boot.txz
rm /etc.txz
rm /var.txz
rm /share.txz
rm /home.txz
rm /root.txz
