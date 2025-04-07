sudo ip netns add ns0
sudo ip link set ens21f0np0 netns ns0
sudo ip netns exec ns0 ip addr add 192.168.10.100/24 dev ens21f0np0
sudo ip netns exec ns0 ip link set ens21f0np0 up

sudo ip netns add ns1
sudo ip link set ens21f1np1 netns ns1
sudo ip netns exec ns1 ip addr add 192.168.10.200/24 dev ens21f1np1
sudo ip netns exec ns1 ip link set ens21f1np1 up


