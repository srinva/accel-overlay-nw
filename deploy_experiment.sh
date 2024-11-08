#!/bin/bash

server1=$2
server2=$3

set -e
replicas=$1
helm upgrade --install accel-overlay-nw-server ./server --set replicas=$replicas
kubectl wait --for=condition=Ready pod -l type=server --timeout=300s
helm upgrade --install accel-overlay-nw-client ./client --set replicas=$replicas
# kubectl wait --for=condition=complete pod -l type=client --timeout=300s
sleep 5
ssh $server1 'mpstat -P ALL 1 > /tmp/mpstat_server1.log &'&   # Start mpstat in background
ssh $server2 'mpstat -P ALL 1 > /tmp/mpstat_server2.log &'&   # Start mpstat in background
sleep 20
ssh $server1 'pkill -SIGINT mpstat'
ssh $server2 'pkill -SIGINT mpstat'
# Save the last 6 lines of mpstat output to log files
ssh $server1 'tail -n 6 /tmp/mpstat_server1.log' > mpstat_client.log
ssh $server2 'tail -n 6 /tmp/mpstat_server2.log' > mpstat_server.log
sleep 15
for i in $(seq 1 $replicas); do
  echo "Server $i:"
  kubectl logs iperf-server-$i | tail -n 3
  echo "Client $i:"
  kubectl logs iperf-client-$i | tail -n 5 | head -n 2
done
# cleanup
helm uninstall accel-overlay-nw-client
helm uninstall accel-overlay-nw-server