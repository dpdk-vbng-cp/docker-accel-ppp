.PHONY: all build build-accel-ppp-drivers run run-accel-ppp-drivers run-accel-pppd clean

KERNEL_VERSION=$(shell uname -r)

all: build
build: build-accel-ppp-drivers build-accel-pppd

build-accel-ppp-drivers:
	docker build \
		--build-arg KERNEL_VERSION=$(KERNEL_VERSION) \
		-t accel-ppp-drivers \
		./accel-ppp-drivers/ubuntu/

build-accel-pppd:
	docker build \
		-t accel-pppd \
		./accel-pppd/

run: run-accel-ppp-drivers run-accel-pppd

run-accel-ppp-drivers:
	docker run \
		--cap-add=SYS_MODULE \
		-v /sbin/modprobe:/sbin/modprobe \
		-v /sbin/depmod:/sbin/depmod \
		-v /lib/modules/$(KERNEL_VERSION):/lib/modules/$(KERNEL_VERSION) \
		-v /etc/modules-load.d/:/etc/modules-load.d \
		--name accel-ppp-drivers \
		-ti \
		accel-ppp-drivers

run-accel-pppd:
	docker run \
		--cap-add=NET_ADMIN \
		--cap-add=ALL \
		--privileged \
		--device /dev/ppp:/dev/ppp \
		-p 2000-2001:2000-2001 \
		-v /sbin/lsmod:/sbin/lsmod \
		--name accel-pppd \
		-d \
		accel-pppd

clean:
	docker kill accel-ppp-drivers accel-pppd || true
	docker rm accel-ppp-drivers accel-pppd
	sudo rmmod ipoe vlan_mon || true
	sudo rm -f /lib/modules/4.18.0-20-generic/extra/ipoe.ko /lib/modules/4.18.0-20-generic/extra/vlan_mon.ko /etc/modules-load.d/accel-ppp.conf
