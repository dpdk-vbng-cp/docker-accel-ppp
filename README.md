# docker-accel-ppp
This repo contains two directories for creating images for accel-ppp:

1. accel-pppd: Container running the accel-ppp daemon
2. accel-ppp-drivers: Container for building the kernel modules and installing
   them to the host (ubuntu)

## Build and run the containers
The Makefile defines targets for building and running the containers:

```
make build
make run
```

Please note that we currently only support ubuntu host machines. The
`KERNEL_VERSION` of the host system can be specified to build the kernel
modules for certain kernel versions. By default the kernel version is read by
`uname -r`.

## Test
We use [test-kitchen](https://kitchen.ci/) with the vagrant driver
[kitchen-vagrant](https://github.com/test-kitchen/kitchen-vagrant) to test our
containers. Please make sure [vagrant](https://www.vagrantup.com/) is installed
and runs properly.

Install bundler `gem install bundler -v '1.17.3'` and install the bundle from the Gemfile
with `bundle install`.

Now you are ready to test the containers with kitchen:

```
kitchen create
kitchen converge
kitchen verify
```

To test if a pppoe connection to the accel-pppd container can be established
login to the vagrant machine with `kitchen login` and run the pppoe client:

```
sudo pppd pty "/usr/sbin/pppoe -I docker0 -T 80 -U -m 1412" noccp ipparam vpeer-client-2 linkname docker0 noipdefault noauth default-asyncmap defaultroute hide-password updetach mtu 1492 mru 1492 noaccomp nodeflate nopcomp novj novjccomp lcp-echo-interval 40 lcp-echo-failure 3 user intel
```
