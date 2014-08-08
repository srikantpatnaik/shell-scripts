#!/system/bin/sh
#
# for WM8880 linux xorg chroot
#
# chroot_env      Start/Stop chroot env daemons
#
# description:  Start/Stop chroot env daemons

chroot_path="/data/linux"

function start_mount() {
	if [ ! -f "$chroot_path/proc/uptime" ]; then
        	mount --bind /proc $chroot_path/proc
	fi

	if [ ! -f "$chroot_path/dev/random" ]; then
        	mount --bind /dev $chroot_path/dev
	fi

	if [ ! -d "$chroot_path/sys/kernel" ]; then
        	mount --bind /sys $chroot_path/sys
	fi

	if [ ! -d "$chroot_path/dev/pts" ]; then
        	mount --bind /dev/pts $chroot_path/dev/pts
	fi
	}

function stop_mount() {
	umount $chroot_path/proc
	umount $chroot_path/dev
	umount $chroot_path/dev/pts
	umount $chroot_path/sys
	}


case "$1" in
start)
	start_mount


	chroot $chroot_path /bin/bash -l
	;;

startx)
	start_mount

	if [ ! -f $chroot_path/dev/fb0 ]; then
 		ln -s /dev/graphics/fb0 /dev/fb0
	fi
 	# kill android UI
	#setprop ctl.stop media & setprop ctl.stop zygote

	#chroot /opt/chroot /bin/bash -c "runuser -l ipynb -c '/opt/rh/python27/root/usr/bin/ipython notebook --profile=nbserver &'"
;;

stop)
	stop_mount
;;

stopx)
	#chroot /opt/chroot /bin/bash -c "runuser -l ipynb -c 'killall ipython'"
	#sleep 3
	#echo "stopped ipython server and unmounting proc and dev"
	stop_mount
;;
*)

echo "Usage: bash mount-script.sh {start|stop|startx|stopx}"
exit 1
esac
exit 0

