FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive

#ENV LINUX_HEADERS_VERSION 4.9.0-9

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y ca-certificates git build-essential cmake pkg-config libnl-3-dev libnl-utils libssl-dev libpcre3-dev libsnmp-dev libnet-snmp-perl libtritonus-bin lua5.1 liblua5.1-0-dev snmp libhiredis-dev libjson-c-dev ppp pppoe iproute2 linux-headers-$(uname -r) gcc g++ gdb strace \
    && build_dir="/opt/accel-ppp" \
    && mkdir "$build_dir" \
    && cd "$build_dir" \
    && git clone https://github.com/dpdk-vbng-cp/accel-ppp.git . \
    && mkdir "$build_dir/build"
