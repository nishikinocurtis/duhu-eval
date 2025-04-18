import time
import ray
import numpy as np
import argparse
import random

parser = argparse.ArgumentParser(description="Microbenchmark for Ray SDM")
parser.add_argument("--num-trials", "-n", type=int, default=100, help="Number of objects")
parser.add_argument("--num-height", "-z", type=int, default=10, help="Height (Z-axis) of the object")
parser.add_argument("--parallel-workers", "-p", type=int, default=16, help="Number of workers")
parser.add_argument("--random-access", "-r", action="store_true", help="Random access")
parser.add_argument("--warmup", "-w", action="store_true", help="Warmup")

args = parser.parse_args()
NUM_TRIALS = args.num_trials
NUM_HEIGHT = args.num_height

NUM_WORKERS = args.parallel_workers


WARMUP = args.warmup
RANDOM_ACCESS = args.random_access

# if RANDOM_ACCESS:
#     access_pos = []
#     for i in range(NUM_WORKERS):
#         access_i = []
#         for _ in range(100000):
#             access_i.append((random.randint(0, 1023), random.randint(0, 1023), random.randint(0, NUM_HEIGHT - 1)))
#         access_pos.append(access_i)

spec_string = "z={}, n={}, workers={}".format(NUM_HEIGHT, NUM_TRIALS, NUM_WORKERS)

ray.init(address='auto')

@ray.remote
def process_data(datas, worker_id):
    sum_d = 0
    
    # time_entry = time.time()
    
    time_before_get = time.time()
    data_real = ray.get(datas) # supposed guess is that, RPC takes ~1s per object, regardless of copy or not.
    inner_start = time.time()
    if RANDOM_ACCESS:
        access_pos = []
        for _ in range(10000):
            access_pos.append((random.randint(0, 1023), random.randint(0, 1023), random.randint(0, NUM_HEIGHT - 1)))
        for arr_d in data_real:
            for pos in access_pos:
                x, y, z = pos
                sum_d += arr_d[x, y, z]
    else:
        sum_d = sum([np.sum(arr_d) for arr_d in data_real])
    inner_end = time.time()
    # print(spec_string, "(id={}, len={}): {} {}".format(worker_id, len(datas), inner_start - time_before_get, inner_end - inner_start))
    return sum_d

@ray.remote
def put_one_array():
    arr = np.ones((1024, 1024, NUM_HEIGHT), dtype=np.float32)
    return arr
    

local_sum = NUM_HEIGHT * NUM_TRIALS * 1024 * 1024 * NUM_WORKERS
if RANDOM_ACCESS:
    local_sum = 10000 * NUM_TRIALS * NUM_WORKERS

# warmup
if WARMUP:
    warmups = []
    arr = np.ones((1024, 1024, NUM_HEIGHT), dtype=np.float32)
    ref = ray.put(arr)
    for i in range(NUM_WORKERS):
        warmup = process_data.remote([ref], i)
        warmups.append(warmup)
    ray.get(warmups)



put_time = 0.0

refs = []

put_refs = []

start_time = time.time()

for i in range(NUM_TRIALS):
    ref = put_one_array.options(
        scheduling_strategy=ray.util.scheduling_strategies.NodeAffinitySchedulingStrategy(
            node_id=ray.get_runtime_context().get_node_id(),
            soft=False)
    ).remote()
    put_refs.append(ref)


start_time_after_seal = time.time()

handles = []

node_ids = ray.nodes()



for i in range(NUM_WORKERS):
    worker_refs = put_refs
    work_handle = process_data.options(
        scheduling_strategy=ray.util.scheduling_strategies.NodeAffinitySchedulingStrategy(
            node_id=node_ids[i % len(node_ids)]['NodeID'],
            soft=False)
    ).remote(worker_refs, i)
    handles.append(work_handle)

result = sum(ray.get(handles))


end = time.time()
print(spec_string, end - start_time)


print("sanity check: ", result, local_sum)
# print(spec_string, "put time: ", put_time)

