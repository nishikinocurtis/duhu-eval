# for 1 to 22 exclude 5
for i in {1..22}; do
    if [ $i -ne 5 ]; then
        echo "Running query $i..."
        python queries.py "$i"
        sleep 15
    fi
done

