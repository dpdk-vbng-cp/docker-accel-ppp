FROM bisdn/accel-pppd-base:testing

WORKDIR /opt/accel-ppp/build
RUN set -x \
    && cmake -DRADIUS=TRUE -DNETSNMP=TRUE -DLUA=TRUE -DBUILD_VLAN_MON_DRIVER=TRUE -DCMAKE_INSTALL_PREFIX=/usr -DKDIR=/usr/src/linux-headers-$(uname -r) -DCMAKE_BUILD_TYPE=Debug -DCPACK_TYPE=Ubuntu20 .. \
    && make \
    && make install

COPY etc /etc/

EXPOSE 2000-2001/tcp
#ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["accel-pppd", "-c", "/etc/accel-ppp.conf"]
