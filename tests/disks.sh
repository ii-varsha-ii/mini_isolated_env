#!/bin/sh

output_file="/tmp/file1"
current_size=300
max_size=20000

while [ "$current_size" -le "$max_size" ]; do
    #echo "Running dd with bs=$(echo "$current_size"K) count=1..."
    dd if=/dev/zero of="$output_file" bs=$(echo "$current_size"K) count=1

    # Increment the size by 100K
    current_size=$(echo "$current_size + 1000" | bc)
    sleep 0.2
done

# dd if=/dev/zero of=/tmp/file1 bs=100 count=1