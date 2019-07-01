#!/bin/bash
set -e

S_TAG=${S_TAG:-0}
C_TAGS="$(echo {0..4094})"
IFACE=${IFACE:-eth0}
CORES="$(grep -c ^processor /proc/cpuinfo)"

create_s_tag () {
    iface=$1
    s_tag=$2
    s_iface=$iface.$s_tag
    ip link add link $iface $s_iface type vlan proto 802.1ad id $s_tag
    ip link set $s_iface up
    echo "$s_iface"
}

create_c_tag () {
    iface=$1
    c_tag=$2
    c_iface=$iface.$c_tag
    ip link add link $iface $c_iface type vlan proto 802.1Q id $c_tag
    ip l set $c_iface up
    echo "$c_iface"
}

# Create interface for S-tag
S_IFACE=$(create_s_tag $IFACE $S_TAG)

# Create interfaces for C-tags
export -f create_c_tag
export S_IFACE
printf %s\\n $C_TAGS | xargs -n 1 -P $CORES -I {} bash -c 'create_c_tag "$S_IFACE" "{}" &> /dev/null'

# Run command from CMD
exec "$@"
