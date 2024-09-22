#!/bin/sh

ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.18/releases/aarch64/alpine-minirootfs-3.18.0-aarch64.tar.gz"
CAPSULE="capsule"
ROOT_FS="root_fs"

mkdir ${CAPSULE}

curl ${ALPINE_URL} -o ${CAPSULE}/${CAPSULE}.tar.gz
tar xfz ${CAPSULE}/${CAPSULE}.tar.gz -C ${CAPSULE}/ && rm -f ${CAPSULE}/${CAPSULE}.tar.gz

# tests
mkdir -p ${CAPSULE}/tests
cp -r tests ${CAPSULE}/
cp jailbreak ${CAPSULE}/

# copy ubuntu dd to busybox dd
rm ${CAPSULE}/bin/dd
cp $(which dd) ${CAPSULE}/bin

for library in $(ldd "$(which dd)" | cut -d '>' -f 2 | awk '{print $1}')
do
	[ -f "${library}" ] && cp "${library}" ${CAPSULE}/lib
done

rm ${CAPSULE}/usr/bin/nc
rm ${CAPSULE}/bin/nc
cp $(which nc) ${CAPSULE}/bin

for library in $(ldd "$(which nc)" | cut -d '>' -f 2 | awk '{print $1}')
do
	[ -f "${library}" ] && cp "${library}" ${CAPSULE}/lib
done

# install python and necessary libraries
sudo chroot ${CAPSULE}/ /bin/sh << EOF
touch /etc/resolv.conf
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
apk add python3
apk add py-pip
apk add build-base linux-headers
apk add gcc python3-dev
python -m pip install psutil
EOF

# tar my capsule
# tar -czf root_fs.tar.gz capsule/
tar -czf ${ROOT_FS}.tar.gz ${CAPSULE}/