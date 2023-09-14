#!/bin/bash

# The python script you want to monitor
python_script="Algorithm/FastSlam.py"

# Run the python script in the background & get its PID
python3 $python_script &
PID=$!

# Define a function to handle SIGINT
handle_sigint() {
    kill -9 $PID
    exit
}

# Register the function to be called when SIGINT is received
trap 'handle_sigint' INT

# Create a memory usage log file
mem_log_file="mem_log.txt"
echo "TIME MEMORY" > $mem_log_file

# Monitor the python script memory usage
while ps -p $PID > /dev/null
do
    # Get the current time
    now=$(date +"%s")
    
    # Get the memory usage of the python script
    mem=$(ps -o rss= -p $PID)
    
    # Write the data to the log file
    echo "$now $mem" >> $mem_log_file

    # Wait for a second
    sleep 1
done

# Use gnuplot to create a graph of the memory usage
gnuplot <<- EOF
    set term png
    set output 'memory_usage.png'
    set title "Memory usage over time"
    set xlabel "Time"
    set ylabel "Memory usage (KB)"
    set xdata time
    set timefmt "%s"
    set format x "%H:%M:%S"
    plot "$mem_log_file" using 1:2 title 'Memory usage' with lines
EOF
