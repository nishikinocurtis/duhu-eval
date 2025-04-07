alias duhu-sort1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --privileged \
--device=/dev/mem/cxl \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray1 --network none nishikinocurtis/duhu:sort-duhu'

alias duhu-sort2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --privileged \
--device=/dev/mem/cxl \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray2 --network none nishikinocurtis/duhu:sort-duhu'

alias ray-sort1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --privileged \
-e RAY_BACKEND_LOG_LEVEL=debug \
--name ray1 --network none nishikinocurtis/duhu:sort-ray'

alias ray-sort2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --privileged \
-e RAY_BACKEND_LOG_LEVEL=debug \
--name ray2 --network none nishikinocurtis/duhu:sort-ray'

alias duhu-modin1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --privileged \
--device=/dev/mem/cxl \
-v ./modin/datasets-sf10:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray1 --network none nishikinocurtis/duhu:modin-duhu'

alias duhu-modin2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --privileged \
--device=/dev/mem/cxl \
-v ./modin/datasets-sf10:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray2 --network none nishikinocurtis/duhu:modin-duhu'

alias duhu-daft1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --privileged \
--device=/dev/mem/cxl \
-v ./daft/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray1 --network none nishikinocurtis/duhu:daft-duhu'

alias duhu-daft2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --privileged \
--device=/dev/mem/cxl \
-v ./daft/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug \
-e DUHU_BIND_CORE=1 \
-e DUHU_NT_COPY_THREAD=4 \
--name ray2 --network none nishikinocurtis/duhu:daft-duhu'

alias ray-daft1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --cpuset-mems="0" \
-v ./daft/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray1 --network none nishikinocurtis/duhu:daft-ray'

alias ray-daft2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --cpuset-mems="0" \
-v ./daft/tpcds-sf10:/tmp/tpcds \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray2 --network none nishikinocurtis/duhu:daft-ray'

alias ray-modin1='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="0-15" --cpuset-mems="0" \
-v ./modin/datasets-sf10:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray1 --network none nishikinocurtis/duhu:modin-ray'

alias ray-modin2='docker run -dit --rm --shm-size=50gb -m=50g --cpuset-cpus="16-31" --cpuset-mems="0" \
-v ./modin/datasets-sf10:/tmp/datasets \
-e RAY_BACKEND_LOG_LEVEL=debug --name ray2 --network none nishikinocurtis/duhu:modin-ray'