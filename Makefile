.PHONY: all build build-accel-ppp-drivers build-accel-pppd start start-accel-ppp-drivers start-accel-pppd clean

KERNEL_VERSION?=$(shell uname -r)
UBUNTU_VERSION?=18.04

all: build start

build:
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose build

build-accel-ppp-drivers:
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose build accel-ppp-drivers

build-accel-pppd:
	docker-compose build accel-pppd

start:
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose up -d

start-accel-ppp-drivers:
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose start accel-ppp-drivers

start-accel-pppd:
	docker-compose start accel-pppd

clean:
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose kill || true
	KERNEL_VERSION=$(KERNEL_VERSION) UBUNTU_VERSION=$(UBUNTU_VERSION) docker-compose rm -f || true
	sudo rmmod ipoe vlan_mon || true
	sudo rm -f /lib/modules/4.18.0-20-generic/extra/ipoe.ko /lib/modules/4.18.0-20-generic/extra/vlan_mon.ko /etc/modules-load.d/accel-ppp.conf
