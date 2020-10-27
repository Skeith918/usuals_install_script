#!/bin/bash

read -s -p "set lufi's database password : " lufidbpass

#UPDATE PACKAGE AND INSTALL DEPENDENCIES
apt update && apt upgrade -y
apt-get install build-essential libssl-dev libio-socket-ssl-perl liblwp-protocol-https-perl zlib1g-dev git -y

#INSTALL CARTON AND DB
cpan Carton
apt install libmariadbd-dev mariadb-server -y

cd $(dirname $(which mariadb_config))
ln -s mariadb_config mysql_config

#CONFIGURE DB
mariadb/secure_installation.sh
mysql -e "CREATE DATABASE lufi CHARACTER SET utf8 COLLATE utf8_general_ci";
mysql -e "CREATE USER lufi@'127.0.0.1' IDENTIFIED BY '$lufidbpass'";
mysql -e "GRANT SELECT, INSERT, UPDATE ON lufi.* TO 'lufi'@'127.0.0.1'";

#INSTALL LUFI

git clone https://framagit.org/fiat-tux/hat-softwares/lufi.git && cd lufi

while true
do
        read -r -p "Do you want use htpasswd authentication system ? [Y/n/cancel]" input
        case $input in [yY][eE][sS]|[yY])
	carton install --deployment --without=test --without=sqlite --without=postgresql --without=ldap
        break
        ;;
        [nN][oO]|[nN])
	carton install --deployment --without=test --without=sqlite --without=postgresql --without=htpasswd --without=ldap
	break
        ;;
        [cancel])
        break
        ;;
        *)
        echo "Please answer yes or no or cancel.."
        ;;
        esac
done

cp lufi.conf.template lufi.conf

