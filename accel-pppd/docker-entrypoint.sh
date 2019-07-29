#!/bin/bash
set -e

OUTER_PROTO=${OUTER_PROTO:-802.1ad}
OUTER_TAG=${OUTER_TAG:-0}
INNER_PROTO=${INNER_PROTO:-802.1Q}
INNER_TAGS=${INNER_TAGS:-$(echo {0..4094})}
IFACE=${IFACE:-eth0}
CORES="$(grep -c ^processor /proc/cpuinfo)"

create_vlan_interface () {
    iface=$1
    tag=$2
    proto=$3
    vlan_iface=$iface.$tag
    ip link add link $iface $vlan_iface type vlan proto $proto id $tag
    ip link set $vlan_iface up
    echo "$vlan_iface"
}

if [[ $OUTER_TAG -eq 0 ]]; then # No outer tag
    # Only single VLAN tag, no stacking
    OUTER_IFACE=$IFACE
elif [[ $OUTER_TAG -gt 0 && $OUTER_TAG -lt 4095 ]]; then
    # Create outer VLAN interface
    OUTER_IFACE=$(create_vlan_interface $IFACE $OUTER_TAG $OUTER_PROTO)
else
    >&2 echo "Value $OUTER_TAG for OUTER_TAG not valid."
    exit 1
fi

# Create inner VLAN interfaces
if [[ ! -z $INNER_TAGS ]]; then
    export -f create_vlan_interface
    export OUTER_IFACE
    export INNER_PROTO

    printf "$INNER_TAGS" | xargs -d " " -n 1 -P $CORES -I {} bash -c 'create_vlan_interface "$OUTER_IFACE" "{}" "$INNER_PROTO" &> /dev/null'
fi

# Run command from CMD
exec "$@"
