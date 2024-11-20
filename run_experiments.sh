#!/bin/bash

SERVER_IP=$2
NUM_RUNS=2
FIRST_ARG=$1

cpu_charts=""
numbers=""
cpu_data=""

for i in $(seq 1 $NUM_RUNS); do
  echo "Running experiment $i..."
  output=$(./deploy_experiment.sh $FIRST_ARG $SERVER_IP)
  if [ $? -ne 0 ]; then
    echo "Experiment $i failed to run."
    exit 1
  fi
  echo "Experiment $i completed."
  sleep 5
  
  cpu_chart=$(echo "$output" | head -n -1)
  number=$(echo "$output" | tail -n 1)
  
  cpu_charts="${cpu_charts}${cpu_chart}\n\n"
  numbers="${numbers}${number} "
  
  cpu_data="${cpu_data}$(echo "$cpu_chart" | grep -E 'all|[0-9]+(\.[0-9]+)?' | awk '{print $NF}')\n"
done

echo -e "$cpu_charts"
echo -e "\nNumbers grid:"
echo -e "$numbers" | xargs -n $NUM_RUNS

# Process and print CPU utilization values
cores=$(echo -e "$cpu_data" | grep -oP '^[0-9]+' | sort -u)
metrics=("idle" "soft" "sys" "usr")

for core in $cores; do
  for metric in "${metrics[@]}"; do
    values=$(echo -e "$cpu_data" | grep -P "^$core\s" | awk -v metric="$metric" '{if (metric == "idle") print $12; else if (metric == "soft") print $10; else if (metric == "sys") print $8; else if (metric == "usr") print $4;}')
    echo "Core $core $metric: $values"
  done
done