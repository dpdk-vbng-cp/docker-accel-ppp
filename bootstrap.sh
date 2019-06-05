sudo apt -y update
sudo apt install -y docker.io docker-compose
cd /opt/docker-accel-ppp
make build
make run
