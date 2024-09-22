#
# Created on Sat Sep 21 2024
#
# Author: Varsha Natarajan ( varshanatarajan311298@gmail.com )
#

#!/bin/sh

ROOT_FS="root_fs"
CAPSULE_NETNS="capsule_ns_"$$

mkdir ${ROOT_FS} || true

chmod +x ${ROOT_FS}

if [ -z "$(ls -A ${ROOT_FS})" ]; then
   echo "folder is empty. Unzipping the tar"
   tar xfz ${ROOT_FS}.tar.gz --strip-components 1 -C ${ROOT_FS}
fi

sudo umount -Rqf ${ROOT_FS}/tmp || true
sudo umount -Rqf ${ROOT_FS}/sys || true
sudo umount -Rqf ${ROOT_FS}/dev || true

sudo mount -t sysfs sys ${ROOT_FS}/sys || true

sudo mount --rbind /tmp ${ROOT_FS}/tmp
sudo mount --make-rprivate  ${ROOT_FS}/tmp

#sudo mount --rbind /sys ${ROOT_FS}/sys
#sudo mount --make-rprivate ${ROOT_FS}/sys

sudo mount -t devtmpfs dev ${ROOT_FS}/dev

# create capsule_netns
if [ ! -f  /run/netns/${CAPSULE_NETNS} ]
then
  touch /run/netns/${CAPSULE_NETNS}
fi

# create a new pid, mount, ipc, network, fork namespace
# sudo unshare -p -f -m -U -r -n -i --mount-proc=root_fs_1/proc chroot root_fs_1/ /bin/sh
unshare -p -f -m -r --net=/run/netns/${CAPSULE_NETNS}  -i -u --propagation private --mount-proc=${ROOT_FS}/proc chroot ${ROOT_FS}/ /bin/sh

sudo umount -Rqf ${ROOT_FS}/tmp || true
sudo umount -Rqf ${ROOT_FS}/sys || true
sudo umount -Rqf ${ROOT_FS}/dev || true