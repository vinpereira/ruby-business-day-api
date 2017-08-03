#!/bin/bash

# Install requirements
apt update
apt-get install -y vim apt-transport-https ca-certificates curl software-properties-common

# Install docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt-get update
apt-get install -y docker-ce

# Run docker without sudo
gpasswd -a ubuntu docker

# Install docker compose
DOCKER_COMPOSE_VERSION=1.14.0
rm /usr/local/bin/docker-compose
curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` > docker-compose
chmod +x docker-compose
mv docker-compose /usr/local/bin
docker-compose --version

# Install Nginx
apt-get update
apt-get install -y nginx
cp /tmp/nginx.conf /etc/nginx/sites-available/default
service nginx restart

# Install AWS code deploy
apt-get update
apt-get install -y python-pip ruby wget
cd /home/ubuntu
wget https://aws-codedeploy-us-east-1.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
