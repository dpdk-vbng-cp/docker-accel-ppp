FROM bisdn/accel-pppd-base

WORKDIR /opt/accel-ppp/build
RUN set -x \
    && cmake -DRADIUS=TRUE -DNETSNMP=TRUE -DLUA=TRUE .. \
    && make \
    && make install

COPY etc /etc/
COPY docker-entrypoint.sh /usr/local/bin/

EXPOSE 2000-2001/tcp
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
CMD ["accel-pppd", "-c", "/etc/accel-ppp.conf"]
