export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set enp0s8 up
ip link set enp0s9 up
ip addr add 172.16.1.1/24 dev enp0s8
ip addr add 172.16.2.1/24 dev enp0s8
ip addr add 172.16.0.1/30 dev enp0s9
ip route add 172.16.4.0/23 via 172.16.0.2 dev enp0s9 src 172.16.0.1
sysctl -w net.ipv4.ip_forward=1
