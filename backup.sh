#!/bin/sh
backup="sda/Wyatt/$(date +%Y_%m_%d_%T)/"
tar cvJf /boot.txz /boot/
tar cvJf /etc.txz --exclude /etc/dolphin-iso /etc/
tar cvJf /var.txz --exclude /var/cache --exclude /var/lib /var/
tar cvJf /share.txz /shared/
tar cvJf /home.txz --exclude /home/aftix/torrent --exclude /home/aftix/.local/share/Steam /home/
tar cvJf /root.txz /root/

cd /
for name in $(ls . | grep '\.txz') ; do
    curl -x '127.0.0.1:3128' -s -T $name -u anonymous:a --ftp-create-dirs ftp://192.168.0.1/$backup$name
    rm $name
done
