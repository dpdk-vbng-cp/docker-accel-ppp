# docker-accel-ppp
1. Build accel-ppp image: `sudo docker build -t accel-ppp`
2. Run accel-ppp container: `docker run -ti -p 2000-2001:2000-2001 --device=/dev/ppp:/dev/ppp --cap-add=NET_ADMIN accel-ppp`
3. Connect: `sudo pppd pty "/usr/sbin/pppoe -I docker0 -T 80 -U -m 1412" noccp ipparam vpeer-client-2 linkname docker0 noipdefault noauth default-asyncmap defaultroute hide-password updetach mtu 1492 mru 1492 noaccomp nodeflate nopcomp novj novjccomp lcp-echo-interval 40 lcp-echo-failure 3 user intel`
