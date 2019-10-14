FROM ubuntu:18.04

ARG KERNEL_VERSION=4.18.0-20-generic

RUN set -x \
    && apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -y apt-utils ca-certificates git build-essential cmake libpcre3-dev libssl-dev pkg-config libhiredis-dev libjson-c-dev linux-headers-$KERNEL_VERSION libelf-dev \
    && build_dir="/opt/accel-ppp" \
    && mkdir "$build_dir" \
    && cd "$build_dir" \
    && git clone https://github.com/dpdk-vbng-cp/accel-ppp.git . \
    && mkdir "$build_dir/build"
