# for 1 to 22 exclude 5
for i in {1..3}; do
    if [ $i -ne 5 ]; then
        echo "Running query $i..."
        python queries.py "$i"
        sleep 10
    fi
done

