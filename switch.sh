export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y tcpdump
apt-get install -y openvswitch-common openvswitch-switch apt-transport-https ca-certificates curl software-properties-common

# Startup commands for switch go here
ip link set enp0s8 up
ip link set enp0s9 up
ip link set enp0s10 up
ovs-vsctl add-br br0
ovs-vsctl add-port br0 enp0s8
ovs-vsctl add-port br0 enp0s9
ovs-vsctl add-port br0 enp0s10
