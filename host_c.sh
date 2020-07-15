export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set enp0s8 up
ip addr add 172.16.4.2/23 dev enp0s8
ip route add 172.16.0.0/22 via 172.16.4.1 dev enp0s8
