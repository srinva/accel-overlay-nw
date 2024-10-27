#!/bin/bash

set -e
replicas=$1
helm upgrade --install accel-overlay-nw-server ./server --set replicas=$replicas
sleep 5
helm upgrade --install accel-overlay-nw-client ./client --set replicas=$replicas
sleep 31
for i in $(seq 1 $replicas); do
  echo "Server $i"
  kubectl logs iperf-server-$i | tail -n 3
done