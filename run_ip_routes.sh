#
# Created on Sat Sep 21 2024
#
# Author: Varsha Natarajan ( varshanatarajan311298@gmail.com )
#
#!/bin/sh
sudo ip route add ${CAPSULE1_IP}/32 via ${HOST1_IP} # in HOST2
sudo ip route add ${CAPSULE2_IP}/32 via ${HOST2_IP} # in HOST1