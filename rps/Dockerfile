FROM debian:bookworm-slim

# RUN mount -o remount,rw '/sys/class/net/'
# RUN chmod -R 777 /sys/class/net/
RUN apt-get update
RUN apt-get install dos2unix

RUN apt-get install -y iperf3 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 5201

COPY enable_rps.sh /usr/local/bin/enable_rps.sh
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN dos2unix /usr/local/bin/enable_rps.sh
RUN dos2unix /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/enable_rps.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
