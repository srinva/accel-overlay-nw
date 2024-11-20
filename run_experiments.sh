#!/bin/bash

SERVER_IP=$2
NUM_RUNS=10
FIRST_ARG=$1

cpu_charts=""
numbers=""

for i in $(seq 1 $NUM_RUNS); do
  output=$(./deploy_experiment.sh $FIRST_ARG $SERVER_IP)
  cpu_chart=$(echo "$output" | head -n -1)
  number=$(echo "$output" | tail -n 1)
  
  cpu_charts="${cpu_charts}${cpu_chart}\n\n"
  numbers="${numbers}${number} "
done

echo -e "$cpu_charts"
echo -e "\nNumbers grid:"
echo -e "$numbers" | xargs -n $NUM_RUNS