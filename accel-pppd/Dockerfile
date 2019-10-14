FROM bisdn:accel-pppd-base

RUN set -x \
    && build_dir="/opt/accel-ppp" \
    && mkdir "$build_dir" \
    && cd "$build_dir" \
    && git clone https://github.com/dpdk-vbng-cp/accel-ppp.git . \
    && mkdir "$build_dir/build" \
    && cd "build" \
    && cmake -DRADIUS=TRUE -DNETSNMP=TRUE -DLUA=TRUE .. \
    && make \
    && make install

COPY etc /etc/
COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 2000-2001/tcp
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["accel-pppd", "-c", "/etc/accel-ppp.conf"]
