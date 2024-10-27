#!/bin/bash

set -e
replicas=$1
helm upgrade --install accel-overlay-nw-server ./server --set replicas=$replicas
kubectl wait --for=condition=Ready pod -l type=server --timeout=300s
helm upgrade --install accel-overlay-nw-client ./client --set replicas=$replicas
# kubectl wait --for=condition=complete pod -l type=client --timeout=300s
sleep 40
for i in $(seq 1 $replicas); do
  echo "Server $i"
  kubectl logs iperf-server-$i | tail -n 3
done
# cleanup
helm uninstall accel-overlay-nw-client
helm uninstall accel-overlay-nw-server