#!/system/bin/sh
#
# for WM8880 linux xorg chroot

chroot_path=/data/linux

stop_mount() {
        umount $chroot_path/proc
        umount $chroot_path/dev/pts
        umount $chroot_path/dev
        umount $chroot_path/sys
        }


        stop_mount
        setprop ctl.start media & setprop ctl.start zygote & setprop ctl.start surfaceflinger & setprop ctl.start drm


