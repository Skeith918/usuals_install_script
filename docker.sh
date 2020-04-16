#!/bin/bash

#SECURITY AND UPDATE
apt update && apt install gnupg2 software-properties-common -y && apt upgrade -y && apt install unattended-upgrades -y

#BASIC DEPENDENCIES
apt install git curl apt-transport-https ca-certificates libffi-dev libssl-dev python3 python3-pip -y
apt-get remove python-configparser

#DOCKER
curl -sSL https://get.docker.com | sh
pip3 install docker-compose
usermod -aG docker $USER
