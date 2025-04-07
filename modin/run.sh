scale_factor=10

dataset_dir = "${pwd}/datasets-sf${scale_factor}"

# generate a current date-time string as a directory name
current_time=$(date +"%Y%m%d_%H%M%S")
# create a directory with the current date-time string
log_dir="./logs_${current_time}"
mkdir -p "$log_dir"

echo "Running Modin on baseline first"

./if.sh ray-modin

# docker exec in container ray1, using the existing shell, command ray1
docker exec -d ray1 bash -c "ray1"

# wait ray1 to set up
sleep 20
# docker exec in container ray2, using the existing shell, command ray2
docker exec -d ray2 bash -c "ray2"
# wait ray2 to set up
sleep 10

# run the test
docker exec -d ray1 bash -c './tpch.sh > /tmp/output.log 2>&1'
docker exec -it ray1 tail -f /tmp/output.log

# we'll be blocked until quit from shell
docker cp ray1:/tmp/output.log ./output.log
docker cp ray1:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet1.out
docker cp ray2:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet2.out

# terminate the containers
docker exec -it ray2 bash -c 'ray stop'
docker exec -it ray1 bash -c 'ray stop'
docker stop ray1 ray2

echo "Finished running Modin on baseline"

echo "Running Modin on DUHU"
./if.sh duhu-modin

# docker exec in container ray1, using the existing shell, command ray1
docker exec -d ray1 bash -c "cr"
docker exec -d ray2 bash -c "cr"

sleep 10

docker exec -d ray1 bash -c "ray1"

# wait ray1 to set up
sleep 20
# docker exec in container ray2, using the existing shell, command ray2
docker exec -d ray2 bash -c "ray2"
# wait ray2 to set up
sleep 10

# run the test
docker exec -d ray1 bash -c './tpch.sh > /tmp/output.log 2>&1'
docker exec -it ray1 tail -f /tmp/output.log

# we'll be blocked until quit from shell
docker cp ray1:/tmp/output.log ${log_dir}/duhu-output.log
docker cp ray1:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/duhu-raylet1.out
docker cp ray2:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/duhu-raylet2.out

# terminate the containers
docker exec -it ray2 bash -c 'ray stop'
docker exec -it ray1 bash -c 'ray stop'
docker stop ray1 ray2