#!/bin/bash

# --- Config ---
worker_id_fragment="81e3ca7b3042115a5310005181c594effcfd42c37e047e9a68"
source_file="raylet-4-m4.out"
search_files=("raylet-1-m1.out" "raylet-2-m2.out" "raylet-3-m3.out")

# --- Step 1: Extract object IDs from raylet-4-m4.out ---
echo "Extracting object IDs from $source_file..."

object_ids=$(grep "Worker $worker_id_fragment" "$source_file" | \
             grep -oE 'object [0-9a-f]+' | \
             awk '{print $2}' | sort | uniq)

echo "Found $(echo "$object_ids" | wc -l) unique object IDs."
echo

# --- Step 2: Search each ID in other raylet logs ---
for obj_id in $object_ids; do
    found_in=()
    sdm_hits=()

    for file in "${search_files[@]}"; do
        if grep -q "$obj_id" "$file"; then
            found_in+=("$file")

            if grep -q "Moving to SDM object $obj_id" "$file"; then
                sdm_hits+=("$file")
            fi
        fi
    done

    if [ ${#found_in[@]} -eq 0 ]; then
        echo "Object ID $obj_id not found in any other file."
    else
        echo "Object ID $obj_id found in: ${found_in[*]}"
        if [ ${#sdm_hits[@]} -eq 0 ]; then
            echo "  ↳ Not moved to SDM in any of them."
        else
            echo "  ↳ Moved to SDM in: ${sdm_hits[*]}"
        fi
    fi
done