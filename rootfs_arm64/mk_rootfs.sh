#!/bin/bash

sudo rm -rf rootfs
sudo rm -rf tmpfs
sudo rm -rf arm64_ramdisk*
 
sudo mkdir rootfs
sudo cp busybox-1.28.4/_install/*  rootfs/ -raf
 
sudo mkdir -p rootfs/proc/
sudo mkdir -p rootfs/sys/
sudo mkdir -p rootfs/tmp/
sudo mkdir -p rootfs/root/
sudo mkdir -p rootfs/var/
sudo mkdir -p rootfs/mnt/
 
sudo cp etc rootfs/ -arf
 
sudo cp -arf /usr/aarch64-linux-gnu/lib rootfs/
 
sudo rm rootfs/lib/*.a
# sudo arm-linux-gnueabi-strip rootfs/lib/*
 
sudo mkdir -p rootfs/dev/
sudo mknod rootfs/dev/tty1 c 4 1
sudo mknod rootfs/dev/tty2 c 4 2
sudo mknod rootfs/dev/tty3 c 4 3
sudo mknod rootfs/dev/tty4 c 4 4
sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3
 
sudo dd if=/dev/zero of=arm64_ramdisk bs=1M count=32
sudo mkfs.ext4 -F arm64_ramdisk
 
sudo mkdir -p tmpfs
sudo mount -t ext4 arm64_ramdisk tmpfs/ -o loop
sudo cp -r rootfs/*  tmpfs/
sudo umount tmpfs
 
sudo gzip --best -c arm64_ramdisk > arm64_ramdisk.gz
sudo mkimage -n "ramdisk" -A arm -O linux -T ramdisk -C gzip -d arm64_ramdisk.gz arm64_ramdisk.img

# clean
rm -f arm64_ramdisk
rm -f arm64_ramdisk.gz
sudo rm -rf rootfs
sudo rm -rf tmpfs
