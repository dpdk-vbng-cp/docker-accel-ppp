#!/bin/bash
set -e


OUTER_PROTO=${OUTER_PROTO:-802.1ad}
OUTER_TAG=${OUTER_TAG:-0}
INNER_PROTO=${INNER_PROTO:-802.1Q}
INNER_TAGS=${INNER_TAGS:-$(echo {0..4094})}
IFACE=${IFACE:-eth0}
CORES="$(grep -c ^processor /proc/cpuinfo)"
BRIDGE=${BRIDGE:-bridge0}
KUBERNETES=${KUBERNETES:-false}
VXLAN_ID=${VXLAN_ID:-200}
VXLAN_IFACE=${VXLAN_IFACE:-vxlan$VXLAN_ID}
VXLAN_LOCAL=${VXLAN_LOCAL:-172.16.248.234}
VXLAN_REMOTE=${VXLAN_REMOTE:-172.16.248.152}
VXLAN_DST_PORT=${VXLAN_DST_PORT:-4789}

if [[ "$KUBERNETES" = true ]]; then
    # Update config file
    if [[ -e /etc/accel-ppp-temp.conf ]]; then
        envsubst < /etc/accel-ppp-temp.conf > /etc/accel-ppp.conf
    fi
    # Create bridge interface
    ip link add name $BRIDGE type bridge || true
    ip link set $BRIDGE up
    # Add VXLAN_LOCAL ip to IFACE
    ip a a $VXLAN_LOCAL/24 dev $IFACE || true
    # Create vxlan interface and attach to bridge
    ip l add $VXLAN_IFACE type vxlan id $VXLAN_ID dstport $VXLAN_DST_PORT local $VXLAN_LOCAL remote $VXLAN_REMOTE || true
    ip l set $VXLAN_IFACE master $BRIDGE || true
    ip link set $VXLAN_IFACE up
    ip link set $VXLAN_IFACE master $BRIDGE || true
    # Attach IFACE to bridge
    ip link set $IFACE master $BRIDGE || true
fi


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
