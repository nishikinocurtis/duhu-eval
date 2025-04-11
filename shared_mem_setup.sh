#!/bin/bash

sudo rm -f /mnt/numa1-shm/sdm
sudo mkdir -p /mnt/numa1-shm
sudo mount -t tmpfs -o size=127G tmpfs /mnt/numa1-shm
numactl --membind=1 dd if=/dev/zero of=/mnt/numa1-shm/sdm bs=1M count=129024
