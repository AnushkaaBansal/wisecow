#!/bin/bash

# Thresholds
CPU_THRESHOLD=80
MEM_THRESHOLD=90
DISK_THRESHOLD=85

# Check CPU Usage
CPULOAD=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
if (( $(echo "$CPULOAD > $CPU_THRESHOLD" | bc -l) )); then
    echo "ALERT: High CPU Load $CPULOAD%" 
fi

# Check Memory Usage
MEMUSAGE=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
if (( $(echo "$MEMUSAGE > $MEM_THRESHOLD" | bc -l) )); then
    echo "ALERT: High Memory Usage $MEMUSAGE%" 
fi

# Check Disk Usage (root partition)
DISKUSAGE=$(df / | grep / | awk '{print $5}' | sed 's/%//g')
if [ "$DISKUSAGE" -gt "$DISK_THRESHOLD" ]; then
    echo "ALERT: High Disk Usage $DISKUSAGE%" 
fi

# List Top 5 Memory-consuming processes
echo "Top 5 Memory Consuming Processes:"
ps aux --sort=-%mem | head -n 6
