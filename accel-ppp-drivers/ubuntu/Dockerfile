FROM bisdn/accel-ppp-drivers-base

COPY load_kernel_modules.sh /usr/local/bin/

ARG KERNEL_VERSION=4.18.0-20-generic
ARG KDIR=/usr/src/linux-headers-$KERNEL_VERSION
# Only required for kernel < 2.6.37
ARG BUILD_PPTP_DRIVER=FALSE
ARG BUILD_IPOE_DRIVER=TRUE
ARG BUILD_VLAN_MON_DRIVER=TRUE

ENV KERNEL_VERSION=$KERNEL_VERSION \
    BUILD_PPTP_DRIVER=$BUILD_PPTP_DRIVER \
    BUILD_IPOE_DRIVER=$BUILD_IPOE_DRIVER \
    BUILD_VLAN_MON_DRIVER=$BUILD_VLAN_MON_DRIVER \
    LOAD_KMOD=ipoe\ vlan_mon


WORKDIR /opt/accel-ppp/build
RUN set -x \
    && cmake -DBUILD_PPTP_DRIVER=$BUILD_PPTP_DRIVER -DBUILD_IPOE_DRIVER=$BUILD_IPOE_DRIVER -DBUILD_VLAN_MON_DRIVER=$BUILD_VLAN_MON_DRIVER -DKDIR=$KDIR .. \
    && if [ "$BUILD_PPTP_DRIVER" = "TRUE" ]; then cd "$build_dir/build/drivers/pptp"; make; fi \
    && if [ "$BUILD_IPOE_DRIVER" = "TRUE" ]; then cd "$build_dir/build/drivers/ipoe"; make; fi \
    && if [ "$BUILD_VLAN_MON_DRIVER" = "TRUE" ]; then cd "$build_dir/build/drivers/vlan_mon"; make; fi

VOLUME /lib/modules/$KERNEL_VERSION
CMD /usr/local/bin/load_kernel_modules.sh
