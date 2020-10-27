# Install dependencies

apt update && apt install unzip jq -y

function read_param (){
  param=$(jq -r '.'$1'.'$2'' ./nextcloud/env_upgrade.json)
  echo $param
}

function set_param (){
nextcloud_sysuser=$(read_param nextcloud sysuser)
nextcloud_current_dir=$(read_param nextcloud parent_pathdir)
nextcloud_app_dir=$(read_param nextcloud appdir_name)
nextcloud_wanted_version=$(read_param nextcloud wanted_version)
nextcloud_current_version=$(sudo -u $nextcloud_sysuser php $nextcloud_current_dir/$nextcloud_app_dir/occ --version | tail -n1 | cut -d ' ' -f2)
nextcloud_backup_dir=/opt/nextcloud-$nextcloud_current_version-backup-`date +"%Y%m%d"`

nextcloud_dbuser=$(read_param nextcloud dbuser)
nextcloud_dbpass=$(read_param nextcloud dbpass)
nextcloud_dbhost=$(read_param nextcloud dbhost)
nextcloud_db=$(read_param nextcloud dbname)
}

set_param

# Enable maintenance mode
sudo -u $nextcloud_sysuser php $nextcloud_current_dir/$nextcloud_app_dir/occ maintenance:mode --on

# Backup nextcloud directory and database

mkdir -p $nextcloud_backup_dir
cp -r $nextcloud_current_dir/$nextcloud_app_dir $nextcloud_backup_dir/nextcloud-app
mysqldump --single-transaction -h $nextcloud_dbhost -u $nextcloud_dbuser -p$nextcloud_dbpass $nextcloud_db > $nextcloud_backup_dir/nextcloud-$nextcloud_current_version-sql.bak

# Install new version

systemctl stop nginx
mv $nextcloud_current_dir/$nextcloud_app_dir  $nextcloud_current_dir/$nextcloud_app_dir-$nextcloud_current_version-old
wget -O- https://download.nextcloud.com/server/releases/nextcloud-$nextcloud_wanted_version.zip > $nextcloud_current_dir/nextcloud-$nextcloud_wanted_version.zip
unzip $nextcloud_current_dir/nextcloud-$nextcloud_wanted_version.zip
cp $nextcloud_current_dir/$nextcloud_app_dir-$nextcloud_current_version-old/config/config.php $nextcloud_current_dir/$nextcloud_app_dir/config/config.php
chmod -R $nextcloud_sysuser:www-data $nextcloud_current_dir/$nextcloud_app_dir
systemctl start nginx
sudo -u $nextcloud_sysuser php $nextcloud_current_dir/$nextcloud_app_dir/occ upgrade

# Disable maintenance mode
sudo -u $nextcloud_sysuser php $nextcloud_current_dir/$nextcloud_app_dir/occ maintenance:mode --off
