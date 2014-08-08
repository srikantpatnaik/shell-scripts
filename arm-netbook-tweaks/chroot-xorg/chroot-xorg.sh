#!/system/bin/sh
#
# for WM8880 linux xorg chroot
#
# chroot_env      Start/Stop chroot env daemons
#
# description:  Start/Stop chroot env daemons

chroot_path="/data/linux"

case "$1" in
start)
if [ ! -f "$chroot_path/proc" ]; then
        mount --bind /proc $chroot_path/proc
fi
if [ ! -d "$chroot_path/dev/mapper" ]; then
        mount --bind /dev $chroot_path/dev
fi
chroot /opt/chroot /bin/bash -l

;;
startx)
if [ ! -f "/opt/chroot/proc/uptime" ]; then
        mount --bind /proc /opt/chroot/proc
fi
if [ ! -d "/opt/chroot/dev/mapper" ]; then
        mount --bind /dev /opt/chroot/dev
fi
#chroot /opt/chroot /bin/bash -c "runuser -l ipynb -c '/opt/rh/python27/root/usr/bin/ipython notebook --profile=nbserver &'"
#chroot  /opt/chroot /bin/bash -c "runuser -l ipynb -c '/opt/rh/python27/root/usr/bin/ipython notebook --profile=nbserver --logfile=/home/ipynb/.ipython/profile_nbserver/log/commands.log --debug &> /home/ipynb/.ipython/profile_nbserver/log/ipynb-all.log &'"
;;

stop)
umount $chroot_path/proc
umount $chroot_path/dev
umount $chroot_path/dev/pts
umount $chroot_path/sys
;;

stopx)
#chroot /opt/chroot /bin/bash -c "runuser -l ipynb -c 'killall ipython'"
#sleep 3
#echo "stopped ipython server and unmounting proc and dev"
#umount /opt/chroot/proc
#umount /opt/chroot/dev
;;
*)

echo "Usage: bash mount-script.sh {start|stop|startx|stopx}"
exit 1
esac
exit 0

