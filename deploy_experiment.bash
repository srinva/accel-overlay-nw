set -e
replicas=$1
helm upgrade --install accel-overlay-nw-server ./server --set replicas=$replicas
helm upgrade --install accel-overlay-nw-client ./client --set replicas=$replicas
sleep 31
for i in $(seq 1 $replicas); do
  kubectl logs iperf-server-$i | tail -n 3
done