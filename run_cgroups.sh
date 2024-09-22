#!/bin/sh

CGROUP_NAME='root_fs_cg'

UNSHARE_PID=$(ps -ef | grep "unshare" | grep chroot | grep -v sudo | awk '{print $2}')
SHELL_PID=$(ps -ef | grep ${UNSHARE_PID} | grep -v chroot |  grep /bin/sh | awk '{print $2}')

sudo rmdir "/sys/fs/cgroup/${CGROUP_NAME}" || true
sudo mkdir "/sys/fs/cgroup/${CGROUP_NAME}" || true

echo "+cpu" > sudo /sys/fs/cgroup/cgroup.subtree_control
echo "+cpuset" > sudo /sys/fs/cgroup/cgroup.subtree_control
echo "+memory" > sudo /sys/fs/cgroup/cgroup.subtree_control
echo "+io" > sudo /sys/fs/cgroup/cgroup.subtree_control

echo "20000000" | sudo tee -a /sys/fs/cgroup/${CGROUP_NAME}/memory.max # 20MB. Else the sandbox gets killed immediately
echo "50000 1000000" | sudo tee /sys/fs/cgroup/${CGROUP_NAME}/cpu.max
echo "8:0 rbps=1000000 wbps=1000000" | sudo tee /sys/fs/cgroup/${CGROUP_NAME}/io.max
echo ${SHELL_PID} | sudo tee -a /sys/fs/cgroup/${CGROUP_NAME}/cgroup.procs