#!/bin/bash
# generate a current date-time string as a directory name
current_time=$(date +"%Y%m%d_%H%M%S")
# create a directory with the current date-time string
log_dir="./modin/ray-logs_${current_time}"

echo "Running Modin on baseline first"

docker network create --driver=bridge --subnet=192.168.10.0/24 duhunet

pushd ..

mkdir -p "$log_dir"

for c in {1..22}; do
    if [ $c -ne 5 ]; then
        echo "Running testcase $c..."
        
        ./if-no-nic.sh ray-modin
        echo "start ray on ray1"
        docker exec -d ray1 bash -ic "ray1"
        sleep 10

        for i in {2..4}; do
            cont_name="ray${i}"
            echo "start ray on ${cont_name}"
            docker exec -d ${cont_name} bash -ic "ray${i}"
        done
        sleep 10


        echo "Execute tpch"
        docker exec -it ray1 bash -c "source /opt/conda/etc/profile.d/conda.sh && conda activate ray && python queries.py ${c} > /tmp/output.log"
        # docker exec -it ray1 tail -f /tmp/output.log
        # we'll be blocked until quit from shell

        echo "Collet results and trace"
        docker cp ray1:/tmp/output.log ${log_dir}/output-${c}.log
        for i in {1..4}; do
            cont_name="ray${i}"
            docker cp ${cont_name}:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet${i}-${c}.out

            docker exec -it ${cont_name} bash -c 'ray stop'
            docker stop ${cont_name}
        done
    fi
done



echo "Finished running Modin on baseline"


############################################

echo "Running Modin on DUHU"

log_dir="./modin/duhu-logs_${current_time}"
mkdir -p "$log_dir"

for c in {1..22}; do
    if [ $c -ne 5 ]; then
        bash /home/twang/duhu-eval/shared_mem_setup.sh
        ./if-no-nic.sh ray-modin-duhu 

        # docker exec in container ray1, using the existing shell, command ray1
        for i in {1..4}; do
            cont_name="ray${i}"
            docker exec -d ${cont_name} bash -ic "cr"
        done
        sleep 10

        echo "start ray on ray1"
        docker exec -d ray1 bash -ic "ray1"
        sleep 10
        #
        for i in {2..4}; do
            cont_name="ray${i}"
            echo "start ray on ${cont_name}"
            docker exec -d ${cont_name} bash -ic "ray${i}"
        done
        sleep 10

        # run the test
        echo "execute tpch"
        docker exec -it ray1 bash -c "timeout 100s python queries.py ${c} > /tmp/output.log"

        echo "Collet results and trace"
        docker cp ray1:/tmp/output.log ${log_dir}/output-${c}.log
        for i in {1..4}; do
            cont_name="ray${i}"
            docker cp ${cont_name}:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet${i}-${c}.out

            docker exec -it ${cont_name} bash -c 'ray stop'
            docker stop ${cont_name}
        done

    fi
done

echo "Finished running Modin on Duhu"

docker network rm duhunet