#!/bin/sh
ftpfs="/ftp"
mkdir -p "$ftpfs"
curlftpfs 192.168.0.1 "$ftpfs"
backup="$ftpfs/sda/Wyatt/$(date +%Y_%m_%d_%T)/"
tar cvJf /boot.txz /boot/
tar cvJf /etc.txz --exclude /etc/dolphin-iso /etc/
tar cvJf /var.txz --exclude /var/cache --exclude /var/lib /var/
tar cvJf /share.txz /shared/
tar cvJf /home.txz --exclude /home/aftix/torrent /home/
tar cvJf /root.txz /root/
mv /boot.txz "$backup"
mv /etc.txz "$backup"
mv /var.txz "$backup"
mv /share.txz "$backup"
mv /home.txz "$backup"
mv /root.txz "$backup"
fusermount -u "$ftpfs"
rmdir "$ftpfs"
