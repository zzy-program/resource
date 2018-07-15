#!/bin/bash

sudo rm -rf rootfs
sudo rm -rf tmpfs
sudo rm -f arm32_rootfs.ext4
 
sudo mkdir rootfs
sudo cp busybox-1.28.4/_install/*  rootfs/ -raf
 
sudo mkdir -p rootfs/proc/
sudo mkdir -p rootfs/sys/
sudo mkdir -p rootfs/tmp/
sudo mkdir -p rootfs/root/
sudo mkdir -p rootfs/var/
sudo mkdir -p rootfs/mnt/
 
sudo cp etc rootfs/ -arf
 
sudo cp -arf /usr/arm-linux-gnueabi/lib rootfs/
 
sudo rm rootfs/lib/*.a
sudo arm-linux-gnueabi-strip rootfs/lib/*
 
sudo mkdir -p rootfs/dev/
sudo mknod rootfs/dev/tty1 c 4 1
sudo mknod rootfs/dev/tty2 c 4 2
sudo mknod rootfs/dev/tty3 c 4 3
sudo mknod rootfs/dev/tty4 c 4 4
sudo mknod rootfs/dev/console c 5 1
sudo mknod rootfs/dev/null c 1 3
 
sudo dd if=/dev/zero of=arm32_rootfs.ext4 bs=1M count=32
sudo mkfs.ext4 arm32_rootfs.ext4
 
sudo mkdir -p tmpfs
sudo mount -t ext4 arm32_rootfs.ext4 tmpfs/ -o loop
sudo cp -r rootfs/*  tmpfs/
sudo umount tmpfs
 
sudo chown zzy arm32_rootfs.ext4
sudo chgrp zzy arm32_rootfs.ext4
