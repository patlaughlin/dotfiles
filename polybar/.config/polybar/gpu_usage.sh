#!/bin/bash

# Function to get GPU utilization percentage
get_gpu_utilization() {
    amdgpu_top -J | jq '.devices[0].gpu_busy_percent' | awk '{printf "%.0f", $1}'
}

# Main loop
while true; do
    gpu_util=$(get_gpu_utilization)
    echo "GPU: ${gpu_util}%"
    sleep 5  # Update every 5 seconds
done
