#!/usr/bin/zsh

if [ -z "$1" ]; then
  echo "Usage: $0 alias_name"
  exit 1
fi

base_alias="$1"

source alias-no-nic.sh

# Loop through alias1 and alias2
for i in {1..4}; do
  alias_name="${base_alias}${i}"

  # Check if the alias exists
  if alias "$alias_name" &>/dev/null; then
    echo "Running alias: $alias_name"
    eval "$alias_name"
  else
    echo "Alias '$alias_name' not found."
  fi
done

# setup each container
for i in {1..4}; do
  echo "Setup interface for ${i}"

  container_name="ray${i}"
  ip_addr="192.168.10.20${i}/24"

  pid=$(docker inspect -f'{{.State.Pid}}' ${container_name})

  sudo nsenter -t $pid -n tc qdisc add dev eth0 root handle 1: htb default 10 r2q 100
  sudo nsenter -t $pid -n tc class add dev eth0 parent 1: classid 1:10 htb rate 20gbit ceil 20gbit
  sudo nsenter -t $pid -n tc filter add dev eth0 protocol ip parent 1:0 prio 1 u32 match ip dst 0.0.0.0/0 flowid 1:10
  sudo nsenter -t $pid -n tc qdisc add dev eth0 handle ffff: ingress
  sudo nsenter -t $pid -n tc filter add dev eth0 parent ffff: protocol ip u32 match ip src 0.0.0.0/0 police rate 20gbit burst 10mb drop flowid :1
  # sudo nsenter -t $pid -n tc qdisc add dev eth0 parent 1:1 handle 10: netem delay 0.02ms
done
# sudo ip netns add ns0
# sudo ip netns add ns1
# sudo ip netns exec ns0 ip link add macvlan0 link ens21f0np0 type macvlan mode bridge
# sudo ip netns exec ns1 ip link add macvlan1 link ens21f1np1 type macvlan mode bridge

# pid0=$(docker inspect -f'{{.State.Pid}}' ray1)
# pid1=$(docker inspect -f'{{.State.Pid}}' ray2)

# echo "Setting up $pid0 for ray1"

# sudo ip netns exec ns0 ip link set macvlan0 netns $pid0
# sudo nsenter -t $pid0 -n ip link set macvlan0 name eth0
# sudo nsenter -t $pid0 -n ip link set eth0 up
# # no need to be the same with host interface
# sudo nsenter -t $pid0 -n ip addr add 192.168.10.201/24 dev eth0
# 
# echo "Setting pu $pid1 for ray2"
# 
# sudo ip netns exec ns1 ip link set macvlan1 netns $pid1
# sudo nsenter -t $pid1 -n ip link set macvlan1 name eth0
# sudo nsenter -t $pid1 -n ip link set eth0 up
# # no need to be the same with host interface
# sudo nsenter -t $pid1 -n ip addr add 192.168.10.202/24 dev eth0

# sudo ip link add veth0 type veth peer name veth0-c
# sudo ip link set veth0 netns $pid0
# sudo nsenter -t $pid0 -n ip link set veth0 name net0
# sudo nsenter -t $pid0 -n ip addr add 172.18.0.2/24 dev net0
# sudo nsenter -t $pid0 -n ip link set net0 up
# sudo nsenter -t $pid0 -n ip route add default via 172.18.0.1
# sudo ip addr add 172.18.0.1/24 dev veth0-c
# sudo ip link set veth0-c up
# 
# sudo ip link add veth1 type veth peer name veth1-c
# sudo ip link set veth1 netns $pid1
# sudo nsenter -t $pid1 -n ip link set veth1 name net0
# sudo nsenter -t $pid1 -n ip addr add 172.18.0.3/24 dev net0
# sudo nsenter -t $pid1 -n ip link set net0 up
# sudo nsenter -t $pid1 -n ip route add default via 172.18.0.1
# sudo ip addr add 172.18.0.1/24 dev veth1-c
# sudo ip link set veth1-c up
# 
# 
# sudo iptables -t nat -A POSTROUTING -s 172.18.0.0/24 -o ens1f0 -j MASQUERADE
