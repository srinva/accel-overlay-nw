#!/bin/bash

# need to enable RPS in both the virtio NIC and VXLAN interface
enable_rps() {
  local interface=$1
  local cpumask=$2
  for queue in /sys/class/net/$interface/queues/rx-*; do
    echo $cpumask > $queue/rps_cpus
  done
}

cpumask=f

enable_rps eth1 $cpumask
enable_rps vxlan.calico $cpumask