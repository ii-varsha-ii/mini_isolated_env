CAPSULE='capsule'
ROOT_FS='root_fs'
ROOT_FS_CG='root_fs_cg'

capsule:
	gcc jailbreak.c -o jailbreak
	sh run_capsule.sh
run_unshare:
	sudo sh run_unshare.sh
cgroups:
	sh run_cgroups.sh
net_ns_h1:
	sh run_net_host_1.sh
net_ns_h2:
	sh run_net_host_2.sh
tests:
	sh mem.sh
	sh disks.sh
	python3 test_cpu.py
clean_capsule:
	sudo rm -rf ${CAPSULE}
clean_root_fs:
	sudo umount -Rqf ${ROOT_FS}/tmp || true
	sudo umount -Rqf ${ROOT_FS}/sys || true
	sudo umount -Rqf ${ROOT_FS}/dev || true
	sudo rm -rf ${ROOT_FS}
clean_netns:
	sudo ip -all netns delete
	sudo ip link delete br1
clean:
	sudo rm -rf ${CAPSULE}
	sudo umount -Rqf ${ROOT_FS}/sys || true
	sudo umount -Rqf ${ROOT_FS}/tmp || true
	sudo umount -Rqf ${ROOT_FS}/dev || true
	sudo rm -rf ${ROOT_FS}.tar.gz
	sudo rm -rf ${ROOT_FS}