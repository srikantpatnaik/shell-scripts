#!/system/bin/sh
#
# for WM8880 linux xorg chroot

setprop ctl.stop media & setprop ctl.stop zygote & setprop ctl.stop surfaceflinger & setprop ctl.stop drm

chroot_path="/data/linux"
export HOME=/root
export HOSTNAME=netbook
export DISPLAY=:0

mount /storage/sdcard1/14.04.1_rootfs.img $chroot_path

start_mount() 
	{
        if [ ! -f "$chroot_path/proc/uptime" ]; then
                mount --bind /proc $chroot_path/proc
        fi

        if [ ! -f "$chroot_path/dev/random" ]; then
                mount --bind /dev $chroot_path/dev
                mount --bind /dev/pts $chroot_path/dev/pts
		ln -n /dev/graphics/fb0 /dev/fb0
        fi

        if [ ! -d "$chroot_path/sys/kernel" ]; then
                mount --bind /sys $chroot_path/sys
        fi

        if [ ! -d "$chroot_path/dev/pts" ]; then
                mount --bind /dev/pts $chroot_path/dev/pts
        fi
	 }


        start_mount
        chroot $chroot_path /bin/bash "startx"
        chroot $chroot_path /bin/bash 
