# nextcloud script 

- nextcloud.sh -> install nextcloud and database instance on docker container
- upgrade_nextcloud.sh -> upgrade script only for baremetal nextcloud installation

## Usages

### nextcloud docker

You must set your variables on docker-compose.yml and deploy it with docker-compose command

### nextcloud baremetal upgrade

- Copy the env_upgrade.sample.json file to env_upgrade.json and set your variables to match with your installation 
- exec the script !
