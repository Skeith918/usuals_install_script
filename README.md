# Usuals Installation Script
This is a list of installation and configuration scripts of some services __Only tested on debian buster__ (but it must work on previous version like jessie or stretch and recent version of Ubuntu), just add execution right to the reposity after clone and enjoy !

## Install guide (for noobs and StarPrime) just follow bellow commands ;)
```
apt update && apt upgrade -y && apt install git
git clone https://github.com/Skeith918/usuals_install_script.git
chmod -R a+x usuals_install_script && cd usuals_install_script
```
## List of scripts
Script Name    | Recommended to working with [npm](https://github.com/Skeith918/nginx-proxy-manager_install_script) | Description
-------------  | ----------- | -------------
npm.sh | this is npm :p | (WIP) Adaptation of my [script](https://github.com/Skeith918/nginx-proxy-manager_install_script) which install [nginx-proxy-manager](https://github.com/jc21/nginx-proxy-manager)
docker.sh | no | Install lastest version of **Docker**, **Docker-compose** and it dependencies
nginx.sh | no | Install and configure **Nginx**, and optionally SSL and some security configuration
nodejs.sh | no | (SOON) Quick install latest version of **Nodejs**
aws.sh | no | (SOON) Install **aws** and **aws-cli** in virtualenv
matrix.sh | yes | (WIP) Install and configure stack of [Matrix-Synapse](https://github.com/matrix-org/synapse) / [Riot](https://github.com/vector-im/riot-web) / [CoTurn](https://github.com/coturn/coturn) in one server.
waveline.sh | yes | (SOON) Install and configure [Waveline Server](https://github.com/Wellenline/waveline-server) and it [Web App](https://github.com/Wellenline/waveline-web)
