alias ray-modin-duhu1='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="0-7" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray1 \
--ip 192.168.10.201 \
--name ray1 nishikinocurtis/duhu:modin-duhu'

alias ray-modin-duhu2='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="8-15" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray2 \
--ip 192.168.10.202 \
--name ray2 nishikinocurtis/duhu:modin-duhu'


alias ray-modin-duhu3='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="60-67" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray3 \
--ip 192.168.10.203 \
--name ray3 nishikinocurtis/duhu:modin-duhu'

alias ray-modin-duhu4='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="68-75" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray4 \
--ip 192.168.10.204 \
--name ray4 nishikinocurtis/duhu:modin-duhu'

alias ray-sort1='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="0-7" --privileged \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray1 \
--ip 192.168.10.201 \
--name ray1 nishikinocurtis/duhu:sort-ray'

alias ray-sort2='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="8-15" --privileged \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray2 \
--ip 192.168.10.202 \
--name ray2 nishikinocurtis/duhu:sort-ray'

alias ray-sort3='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="60-67" --privileged \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray3 \
--ip 192.168.10.203 \
--name ray3 nishikinocurtis/duhu:sort-ray'

alias ray-sort4='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="68-75" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray4 \
--ip 192.168.10.204 \
--name ray4 nishikinocurtis/duhu:sort-ray'

alias ray-sort-duhu1='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="0-7" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray1 \
--ip 192.168.10.201 \
--name ray1 nishikinocurtis/duhu:sort-duhu'

alias ray-sort-duhu2='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="8-15" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray2 \
--ip 192.168.10.202 \
--name ray2 nishikinocurtis/duhu:sort-duhu'

alias ray-sort-duhu3='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="60-67" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray3 \
--ip 192.168.10.203 \
--name ray3 nishikinocurtis/duhu:sort-duhu'

alias ray-sort-duhu4='docker run -dit --rm --shm-size=80gb -m=80g --cpuset-cpus="68-75" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=0 \
-e DUHU_NT_COPY_THREAD=4 \
--network duhunet \
--hostname ray4 \
--ip 192.168.10.204 \
--name ray4 nishikinocurtis/duhu:sort-duhu'

alias ray-daft-duhu1='docker run -dit --rm --shm-size=40gb -m=40g --cpuset-cpus="0-15" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-v /home/twang/dockerfiles/tpcds-sf10:/tmp/tpcds \
-p 6379:6379 -p 8265:8265 -p 9091:9090 -p 10001:10001 \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray1 --network none nishikinocurtis/duhu:daft-duhu'

alias ray-daft-duhu2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --privileged \
--mount type=bind,source=/mnt/numa1-shm,target=/dev/hugepages \
-v /home/twang/dockerfiles/datasets-sf100:/tmp/datasets \
-v /home/twang/dockerfiles/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray2 --network none nishikinocurtis/duhu:daft-duhu'

alias ray-daft1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --cpuset-mems="0" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
-v /home/twang/dockerfiles/tpcds-sf10:/tmp/tpcds \
-p 6379:6379 -p 8265:8265 -p 9091:9090 -p 10001:10001 \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray1 --network none nishikinocurtis/duhu:daft-ray'

alias ray-daft2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --cpuset-mems="0" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
-v /home/twang/dockerfiles/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray2 --network none nishikinocurtis/duhu:daft-ray'

alias ray-modin1='docker run -dit --rm --shm-size=35gb -m=60g --cpuset-cpus="0-7" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
--network duhunet \
--hostname ray1 \
--ip 192.168.10.201 \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray1 nishikinocurtis/duhu:modin-ray'
alias ray-modin2='docker run -dit --rm --shm-size=35gb -m=60g --cpuset-cpus="8-15" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
--network duhunet \
--hostname ray2 \
--ip 192.168.10.202 \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray2 nishikinocurtis/duhu:modin-ray'
# -p 6379:6379 -p 8265:8265 -p 9091:9090 -p 10001:10001 \
alias ray-modin3='docker run -dit --rm --shm-size=35gb -m=60g --cpuset-cpus="32-39" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
--network duhunet \
--hostname ray3 \
--ip 192.168.10.203 \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray3 nishikinocurtis/duhu:modin-ray'
alias ray-modin4='docker run -dit --rm --shm-size=35gb -m=60g --cpuset-cpus="40-47" --cpuset-mems="0" \
-v /home/twang/dockerfiles/datasets-sf10:/tmp/datasets \
--network duhunet \
--hostname ray4 \
--ip 192.168.10.204 \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray4 nishikinocurtis/duhu:modin-ray'

# /home/aguilera/duhu-eval/modin/datasets-sf10
