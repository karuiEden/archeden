#!/usr/bin/bash


mkfs.fat -F32 /dev/vda1
mkfs.btrfs -L "Arch" -f /dev/vda2
mount /dev/sda2 /mnt
cd /mnt
btrfs su cr @
btrfs su cr @home
btrfs su cr @log
btrfs su cr @cache
cd
umount
mount -o noatime,compress=zstd:2,discard=async,subvol=@ /dev/sda2 /mnt
cd /mnt
mkdir /mnt/{home,boot,var}
mkdir /mnt/var/{log,cache}
mkdir /mnt/boot/efi
mount -o noatime,compress=zstd:2,discard=async,subvol=@home /dev/sda2 /mnt/home
mount -o noatime,compress=zstd:2,discard=async,subvol=@log /dev/sda2 /mnt/var/log
mount -o noatime,compress=zstd:2,discard=async,subvol=@cache /dev/sda2 /mnt/var/cache
mount /dev/vda1 /mnt/boot/efi
pacstrap /mnt base linux linux-firmware linux-headers base-devel neovim xorg btrfs-progs
genfstab -U /mnt >> /mnt/etc/fstab
arch-chroot /mnt
ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime

