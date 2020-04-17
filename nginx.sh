#!/bin/bash

NGINX_PATH="/etc/nginx/"
NGINX_CONF_PATH=$NGINX_PATH"nginx.conf"
NGINX_WEB_PATH=$NGINX_PATH"conf.d/"
NGINX_SNIPPETS=$NGINX_PATH"snippets/"

function install_nginx () {
# SECURITY UPDATES AND INSTALL NGINX
echo "Update available packages..."
apt update 1&2>/dev/nul
echo "Upgrade packages..."
apt upgrade -y 1&2>/dev/nul
echo "Install Basic Dependencies..."
apt install gnupg2 software-properties-common -y 1&2>/dev/nul
apt install unattended-upgrades nginx -y 1&2>/dev/null

## BASIC CONFIGURATION
echo "Configure nginx.conf..."
sed -i -e 's/# server_tokens off;/server_tokens off;/g' $NGINX_CONF_PATH
sed -i -e 's/include \/etc\/nginx\/sites-enabled/# include \/etc\/nginx\/sites-enabled/g' $NGINX_CONF_PATH
systemctl restart nginx
main_menu
}

function letsencrypt_conf () {

## DEPENDENCIES
apt update 1&2>/dev/null
apt install certbot openssl -y 1&2>/dev/null

while true
do
	read -r -p "Enter the numbers of bits for your dhparam (2048 or 4096) : " input
	case $input in [2][0][4][8]|[4][0][9][6])
		openssl dhparam -out /etc/ssl/certs/dhparam.pem $input
	break
	;;
	*)
	echo "Please enter a valid value (2048 or 4096)"
	;;
	esac
done

## CONFIGURATION FILE INSTALLATION
mkdir -p /var/lib/letsencrypt/.well-known && chgrp www-data /var/lib/letsencrypt && chmod g+s /var/lib/letsencrypt
cp ./nginx/letsencrypt.conf $NGINX_SNIPPETS\letsencrypt.conf
cp ./nginx/ssl.conf $NGINX_SNIPPETS\ssl.conf
cp ./nginx/sample.conf $NGINX_WEB_PATH\sample.conf

echo "Done !"
echo "Just copy sample.conf virtualhost file in /etc/nginx/conf.d/sample.conf and modify !"
read -r -p "Got it ? [Y/n]" input
main_menu
}

function ssl_cert_gen () {
while true
do
	read -p "Enter your domain name (Ensure you have an type A redirection to this server !) : " domain
	read -p "Enter your email address to receive certificate expiration alert : " email
	echo "You want to generate ssl certificate for domain "$domain" with the email address "$email"..."
	read -r -p "Are you sure of this informations ? [Y/n/cancel]" input
        case $input in [yY][eE][sS]|[yY])
		cp $NGINX_WEB_PATH\sample.conf $NGINX_WEB_PATH$domain.conf
		sed -i -e 's/example.com/'$domain'/g' $NGINX_WEB_PATH$domain.conf
		systemctl restart nginx
		certbot certonly --agree-tos --email $email --webroot -w /var/lib/letsencrypt/ -d $domain
		sed -i -e 's/#//g' $NGINX_WEB_PATH$domain.conf
		systemctl restart nginx
        break
        ;;
	[nN][oO]|[nN])
	;;
        [cancel])
        break
        ;;
        *)
        echo "Please answer yes or no or cancel.."
        ;;
        esac
done
main_menu
}


# MAIN MENU
function main_menu () {
trap "echo 'Control-C cannot been used now >:) ' ; sleep 1 ; clear ; continue " 1 2 3

while true
do
	clear
	echo "\t NGINX INSTALLATION

	\t 1 -- \t Install Nginx
	\t 2 -- \t Install SSL / Letsencrypt configuration
	\t 3 -- \t Generate sample SSL virtualhost of your domain

	\t Q -- \t QUIT (Leave this menu program)

	\t Type an option
	\t And type RETURN to back to main menu\c"

	read answer
	clear

	case "$answer" in
		[1]*) install_nginx ;;
		[2]*) letsencrypt_conf;;
		[3]*) ssl_cert_gen;;

		[Qq]*)  echo "See you soon..." ; exit 0 ;;
		*)      echo "Please choose an option..." ;;
	esac
	echo ""
	echo "type RETURN to back to main menu"
	read dummy
done
}

main_menu
