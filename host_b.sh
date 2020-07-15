export DEBIAN_FRONTEND=noninteractive
# Startup commands go here
ip link set enp0s8 up
ip addr add 172.16.2.2/24 dev enp0s8
ip route add 172.16.2.0/24 dev enp0s8 src 172.16.2.2
ip route add 172.16.0.0/21 via 172.16.2.1 dev enp0s8
