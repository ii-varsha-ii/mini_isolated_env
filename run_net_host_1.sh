#!/bin/sh

# Setup network namespaces for HOST - Use the same script to create network connections in same host

list_of_capsule_pids=$(ps -ef | grep unshare | grep chroot | awk '{print $13}' | cut -d _ -f 3)
# at max, its defaulted to 5 unique capsule addresses. TODO: can be extended to de dynamic
CAP_ADDR="192.168.1.11/24 192.168.1.12/24 192.168.1.13/24 192.168.1.14/24 192.168.1.15/24"
BRIDGE_ADDR_WITH="192.168.1.10/24"
BRIDGE_ADD="192.168.1.10"

get_element_by_index() {
    local index=$1
    shift $index
    echo "$1"
}

sudo ip link add name br1 type bridge
sudo ip addr add "${BRIDGE_ADDR_WITH}" brd + dev br1

i=1
for pid in ${list_of_capsule_pids}
do
  echo "PID of capsule: $pid"
  cap_addr=$(get_element_by_index $i $CAP_ADDR)
  echo "Capsule addr: $cap_addr"

  sudo ip link add bveth_"${pid}" type veth peer name veth_"${pid}"
  sudo ip link set bveth_"${pid}" up

  sudo ip link set bveth_"${pid}" master br1

  sudo ip link set veth_"${pid}" netns capsule_ns_"${pid}"
  sudo ip netns exec capsule_ns_"${pid}" ip addr add "${cap_addr}" dev veth_"${pid}"
  sudo ip netns exec capsule_ns_"${pid}" ip link set veth_"${pid}" up
  sudo ip netns exec capsule_ns_"${pid}" ip link set lo up

  sudo ip netns exec capsule_ns_"${pid}" ip route
  i=$(expr $i + 1)
done

# bridge setup
for pid in ${list_of_capsule_pids}
do

  sudo ip netns exec capsule_ns_"${pid}" ip route add default via "${BRIDGE_ADD}"
done
sudo ip link set br1 up

# IP forwarding
sudo sysctl -w net.ipv4.ip_forward=1
sudo iptables -t nat -A POSTROUTING -s "${BRIDGE_ADDR_WITH}" -j MASQUERADE


