#!/bin/bash

function SslCertGen () {
while true
do
	read -p "Enter your domain name (Ensure you have an type A redirection to this server !) : " domain
	read -p "Enter your email address to receive certificate expiration alert : " email
	echo "You want to generate ssl certificate for domain "$domain" with the email address "$email"..."
	read -r -p "Are you sure of this informations ? [Y/n/cancel]" input
        case $input in [yY][eE][sS]|[yY])
		cp /etc/nginx/conf.d/sample.conf /etc/nginx/conf.d/$domain.conf
		sed -i -e 's/example.com/'$domain'/g' /etc/nginx/conf.d/$domain.conf
		systemctl restart nginx
		certbot certonly --agree-tos --email $email --webroot -w /var/lib/letsencrypt/ -d $domain
		sleep 30
		sed -i -e 's/#//g' /etc/nginx/conf.d/$domain.conf
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

}
function ssl () {

## DEPENDENCIES
apt update && apt install certbot openssl -y

##DHPARAM

while true
do
	read -r -p "Do You Want Generate Diffie-Hellman Key Now ? (it may take a long time)[Y/n] " input
	case $input in [yY][eE][sS]|[yY])
		openssl dhparam -out /etc/ssl/certs/dhparam.pem 2048
	break
	;;
	[nN][oO]|[nN])
	break
        ;;
	*)
	echo "Please answer yes or no.."
	;;
	esac
done

## CERTBOT
mkdir -p /var/lib/letsencrypt/.well-known && chgrp www-data /var/lib/letsencrypt && chmod g+s /var/lib/letsencrypt
cp ./nginx/letsencrypt.conf /etc/nginx/snippets/letsencrypt.conf
cp ./nginx/ssl.conf /etc/nginx/snippets/ssl.conf
cp ./nginx/sample.conf /etc/nginx/conf.d/sample.conf

echo "Done !"
echo "Just copy sample.conf virtualhost file in /etc/nginx/conf.d/sample.conf and modify !"
while true
do
        read -r -p "Do You want create a basic ssl virtual host with your domain? [Y/n]" input
        case $input in [yY][eE][sS]|[yY])
                SslCertGen
        break
        ;;
        [nN][oO]|[nN])
        break
        ;;
        *)
        echo "Please answer yes or no.."
        ;;
        esac
done
}

# SECURITY UPDATES AND INSTALL NGINX
apt update && apt install gnupg2 software-properties-common -y && apt upgrade -y && apt install unattended-upgrades nginx -y

## BASIC CONFIGURATION

sed -i -e 's/# server_tokens off;/server_tokens off;/g' /etc/nginx/nginx.conf
sed -i -e 's/include \/etc\/nginx\/sites-enabled/# include \/etc\/nginx\/sites-enabled/g' /etc/nginx/nginx.conf
systemctl restart nginx

## SSL CONFIGURATION
while true
do
        read -r -p "Do You want prepare your Nginx web server for SSL ? [Y/n]" input
        case $input in [yY][eE][sS]|[yY])
                ssl
        break
        ;;
        [nN][oO]|[nN])
        break
        ;;
        *)
        echo "Please answer yes or no.."
        ;;
        esac
done
