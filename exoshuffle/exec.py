import subprocess
import os
import time

log_dir=""

configs = [
    "LocalNative32g64",
    "LocalNative32g32",
    "LocalNative16g64",
    "LocalNative16g32",
    "LocalNative16g16",
    "LocalNative4g16",
    "LocalNative1g16",
]

def create_logdir():
    cmd = "date +'%Y%m%d_%H%M%S'"
    rt = subprocess.run(
        cmd, shell=True, text=True,
        stdout=subprocess.PIPE, stderr=subprocess.PIPE)

    
    global log_dir 
    log_dir = f"./logs_{rt.stdout.rstrip()}"
    os.mkdir(log_dir)

def start_ray():
    start_ray1 = 'docker exec -d ray1 bash -ic "ray1"'
    rt = subprocess.run(start_ray1, shell=True)
    time.sleep(15)
    for i in [2,3,4]:
        start_ray_cmd = f'docker exec -d ray{i} bash -ic "ray{i}"'
        subprocess.run(start_ray_cmd, shell=True)
        time.sleep(5)

def stop_ray(run_case, config):
    ### grab traces
    global log_dir
    prefix = f"{run_case}_{config}_"
    cmd = f"docker cp ray1:/tmp/output.log ./exoshuffle/{log_dir}/{prefix}output.log"
    subprocess.run(cmd, shell=True)
    for i in [1,2,3,4]:
        cmd = f"docker cp ray{i}:/tmp/ray/session_latest/logs/raylet.out ./exoshuffle/{log_dir}/{prefix}raylet{i}.out"
        subprocess.run(cmd, shell=True)
    ### 
    for i in [1,2,3,4]:
        start_ray_cmd = f'docker exec -d ray{i} bash -ic "ray stop"'
        subprocess.run(start_ray_cmd, shell=True)
    cmd = 'docker stop ray1 ray2 ray3 ray4'
    subprocess.run(cmd, shell=True)

def run(test_case, config):
    setup_cmd = f"./if-no-nic.sh {test_case}"
    rt = subprocess.run(setup_cmd, shell=True)
    start_ray()
    cmd = f"docker exec -it ray1 bash -ic 'source /opt/conda/etc/profile.d/conda.sh && conda activate ray && ./sort.sh {config} > /tmp/output.log 2>&1'"
    print (cmd)
    subprocess.run(cmd, shell=True)
    # CONFIG=${TESTCASE} sudo -E $(which python) raysort/main.py
    stop_ray(test_case, config)

if __name__ == "__main__":
    create_logdir()
    os.chdir("..")
    for run_case in ["ray-sort"]:
        for index, config in enumerate(configs):
            run(run_case, config)

'''
echo "Running ExoShuffle on baseline first"

# docker exec in container ray1, using the existing shell, command ray1
docker exec -d ray1 bash -c "ray1"

# wait ray1 to set up
sleep 20
# docker exec in container ray2, using the existing shell, command ray2
docker exec -d ray2 bash -c "ray2"
# wait ray2 to set up
sleep 10

# run the test
docker exec -d ray1 bash -c './sort.sh > /tmp/output.log 2>&1'
docker exec -it ray1 tail -f /tmp/output.log

# we'll be blocked until quit from shell
docker cp ray1:/tmp/output.log ./output.log
docker cp ray1:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet1.out
docker cp ray2:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/raylet2.out

# terminate the containers
docker exec -it ray2 bash -c 'ray stop'
docker exec -it ray1 bash -c 'ray stop'
docker stop ray1 ray2

echo "Finished running ExoShuffle on baseline"

echo "Running ExoShuffle on DUHU"
./if-no-nic.sh duhu-sort

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
docker exec -d ray1 bash -c './sort.sh > /tmp/output.log 2>&1'
docker exec -it ray1 tail -f /tmp/output.log

# we'll be blocked until quit from shell
docker cp ray1:/tmp/output.log ${log_dir}/duhu-output.log
docker cp ray1:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/duhu-raylet1.out
docker cp ray2:/tmp/ray/session_latest/logs/raylet.out ${log_dir}/duhu-raylet2.out

# terminate the containers
docker exec -it ray2 bash -c 'ray stop'
docker exec -it ray1 bash -c 'ray stop'
docker stop ray1 ray2
'''
