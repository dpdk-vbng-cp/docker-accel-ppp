#!/bin/bash

DRIVERS_DIR=/opt/accel-ppp/build/drivers/
MODULES_CONF=/etc/modules-load.d/accel-ppp.conf
KMOD_DIR=/lib/modules/$KERNEL_VERSION/extra

function install_kmod {
    drv=$1
    drv_dir=$DRIVERS_DIR/$drv/driver
    cp $drv_dir/$drv.ko $KMOD_DIR
}

function load_kmod {
    kmod=$1
    echo $kmod >> $MODULES_CONF
    depmod -a
    modprobe $kmod
}

mkdir -p $KMOD_DIR
touch $MODULES_CONF

# Install kernel modules
for drv in pptp ipoe vlan_mon; do
    dbuild_driver_var=BUILD_"$(echo $drv | tr a-z A-Z)"_DRIVER
    if [ "${!dbuild_driver_var}" = "TRUE" ]; then
        install_kmod $drv
    fi
done

# Load kernel modules
for kmod in $LOAD_KMOD; do
    load_kmod $kmod
done
