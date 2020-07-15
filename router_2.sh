export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set enp0s8 up
ip link set enp0s9 up
ip addr add 172.16.4.1/23 dev enp0s8
ip addr add 172.16.0.2/30 dev enp0s9
ip route add 172.16.0.0/22 via 172.16.0.1 dev enp0s9 src 172.16.0.2
sysctl -w net.ipv4.ip_forward=1
