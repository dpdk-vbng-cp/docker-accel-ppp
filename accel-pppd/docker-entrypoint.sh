#!/bin/bash
set -e

OUTER_TAG=${OUTER_TAG_TAG:-700}
INNER_TAGS="$(echo {0..4094})"
IFACE=${IFACE:-eth0}
CORES="$(grep -c ^processor /proc/cpuinfo)"

create_vlan_interface () {
    iface=$1
    tag=$2
    proto=${3:-802.1Q}
    vlan_iface=$iface.$tag
    ip link add link $iface $vlan_iface type vlan proto $proto id $tag
    ip link set $vlan_iface up
    echo "$vlan_iface"
}

# Create interface for outer C-tag
OUTER_IFACE=$(create_vlan_interface $IFACE $OUTER_TAG)

# Create interfaces for inner C-tags
export -f create_vlan_interface
export OUTER_IFACE
printf %s\\n $INNER_TAGS | xargs -n 1 -P $CORES -I {} bash -c 'create_vlan_interface "$OUTER_IFACE" "{}" &> /dev/null'

# Run command from CMD
exec "$@"
