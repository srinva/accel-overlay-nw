FROM networkstatic/iperf3

RUN mount -o remount,rw '/sys/class/net/'
RUN chmod -R 777 /sys/class/net/

RUN for file in /sys/class/net/*/queues/rx-*/rps_cpus; do \
        echo f > $file; \
    done
