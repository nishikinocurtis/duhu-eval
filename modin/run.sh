#!/bin/bash
# generate a current date-time string as a directory name
current_time=$(date +"%Y%m%d_%H%M%S")
# create a directory with the current date-time string
log_dir="./modin/logs_${current_time}"

echo "Running Modin on baseline first"

pushd ..
mkdir -p "$log_dir"

 ./if.sh ray-modin
 echo "start ray on ray1"
 docker exec -d ray1 bash -ic "ray1"
 sleep 20
 
 for i in {2..4}; do
     cont_name="ray${i}"
     echo "start ray on ${cont_name}"
     docker exec -d ${cont_name} bash -ic "ray${i}"
 done
 sleep 10
 
 
 echo "Execute tpch"
 docker exec -it ray1 bash -c 'source /opt/conda/etc/profile.d/conda.sh && conda activate ray && ./tpch.sh > /tmp/output.log'
 # docker exec -it ray1 tail -f /tmp/output.log
 # we'll be blocked until quit from shell
 
 echo "Collet results and trace"
 docker cp ray1:/tmp/output.log ${log_dir}/output.log
 for i in {1..4}; do
     cont_name="ray${i}"
     docker cp ${cont_name}:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet${i}.out
 
     docker exec -it ${cont_name} bash -c 'ray stop'
     docker stop ${cont_name}
 done
 
 echo "Finished running Modin on baseline"


############################################

# echo "Running Modin on DUHU"
# bash /home/twang/duhu-eval/shared_mem_setup.sh
# ./if.sh ray-modin-duhu 
# 
# # docker exec in container ray1, using the existing shell, command ray1
# for i in {1..4}; do
#     cont_name="ray${i}"
#     docker exec -d ${cont_name} bash -ic "cr"
# done
# sleep 10
# 
# echo "start ray on ray1"
# docker exec -d ray1 bash -ic "ray1"
# sleep 20
# #
# for i in {2..4}; do
#     cont_name="ray${i}"
#     echo "start ray on ${cont_name}"
#     docker exec -d ${cont_name} bash -ic "ray${i}"
# done
# sleep 10
# 
# # run the test
# echo "execute tpch"
# docker exec -it ray1 bash -c './tpch.sh > /tmp/output.log'
# 
# echo "Collet results and trace"
# docker cp ray1:/tmp/output.log ${log_dir}/output.log
# for i in {1..4}; do
#     cont_name="ray${i}"
#     docker cp ${cont_name}:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet${i}.out
# 
#     docker exec -it ${cont_name} bash -c 'ray stop'
#     docker stop ${cont_name}
# done
# 
# echo "Finished running Modin on Duhu"
