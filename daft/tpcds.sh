cd /tmp/tpcds
# for 1 to 99, just neglect failed queries
for i in {1..99}; do
    echo "Running query $i..."
    python ray_entrypoint.py --question $i --scale-factor 10
    sleep 5
done