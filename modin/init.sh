#!/bin/bash

# Check if scale factor argument is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <scale_factor>, default to 10"
    scale_factor=10
fi

scale_factor=$1
directory="datasets-sf${scale_factor}"

# Check if directory exists
if [ -d "$directory" ]; then
    echo "Directory $directory already exists, skipping generation"
else
    echo "Generating data with scale factor $scale_factor..."
    pip install -r requirements.txt
    python dgen.py "$scale_factor"
fi