#!/bin/sh
set -e
/usr/local/bin/enable_rps.sh
exec iperf3 "$@"