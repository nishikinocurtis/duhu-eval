# duhu-eval

Evaluation set for Duhu

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

