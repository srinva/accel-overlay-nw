#!/bin/sh
set -e
/usr/local/bin/enable_rfs.sh
exec iperf3 "$@"