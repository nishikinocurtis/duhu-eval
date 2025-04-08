# duhu-eval

Evaluation set for Duhu

# TODO

- [ ] ExoShuffle multiple size setting script and config

- [ ] Microbenchmarks python script

- [x] Modin Script

- [x] Daft Script

# Build

All `docker build` command assume build directory to be project root!!!



# Running

```bash
source alias.sh
```

If need to force physical traffic, make sure the interfaces are connected correctly, run

```bash
./net.sh # only first run
```

Make sure to prepare data for modin and daft test cases before running following scripts, check `init.sh` for each sub-directory.

Then for each test cases in `ray-modin`, `duhu-modin`, `ray-daft`, `duhu-daft`, `ray-sort`, `duhu-sort`, `ray-mb`, `duhu-mb`, do:

```bash
./if.sh test-case
```

Which should setup necessary containers and interfaces.

Then you can enter container by

```bash
docker attach ray1
#or
docker attach ray2
```

to modify certain configurations, they are places in `/home/ray/kvs.json` and `/home/ray/.bashrc`.

Or use `run.sh` in each sub-directory to automatically interact with docker and collect data.

# Test Cases

## TPC-H

sf=10, Q = 1-22 exclude 5

## TPC-DS

sf=10, Q = about 30 out of 1-99 

## ExoShuffle

32 = 64 * 0.5
32 = 32 * 1
16 = 64 * 0.25
16 = 32 * 0.5
16 = 16 * 1
4  = 16 * 0.25
1  = 16 * (1/16)

## Microbenchmark

Fanout Single Producer Multiple Reader

Random Access

Memory Pressure: 1 produce 15GB, (15+15 setting) 2 produce 30GB (30 + 30 setting), 3 produce 30GB (30 + 30 setting) 