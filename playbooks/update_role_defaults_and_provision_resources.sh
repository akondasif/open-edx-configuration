RDS=openedx-rds-unizin.cglg2lgriogm.us-east-1.rds.amazonaws.com
DOMAIN=openedx-unizin2.testing.unizin.org
PREVIEWURL=openedx-preview-unizin2.testing.unizin.org
S3STORAGEBUCKET=unizin-openedx-unizin
APP=172.31.9.16
MONGO1=172.31.10.161
MONGO2=172.31.0.152
ELASTIC=172.31.6.222
RABBIT=172.31.6.222
# We need to modify these values in files 

# RDS
# roles/setup_rds/defaults/main.yml 
# Line 6 edxRdsHost: 'localhost'

# forum 
# roles/forum/defaults/main.yml 
# Line 17 FORUM_MONGO_HOSTS:
# Line 18   - "localhost"

# mongo_2_6
# line 7 mongo_cluster_members: [localhost]
# edxapp
# Line 66 EDXAPP_MONGO_HOSTS: ['localhost']
# Line 90 EDXAPP_MYSQL_HOST: 'localhost'
# Line 150 EDXAPP_PLATFORM_NAME: 'UNIZIN OpenEdX'
# Line 151 EDXAPP_STUDIO_NAME: 'UNIZIN Studio'
# Line 152 EDXAPP_STUDIO_SHORT_NAME: 'COURSE Studio'
# Line 168,169 Line 287 to 289 and line 309 update your email addresses.
# The script will take care of all lines required to modify


# This function will show 
# all current values from the repo.
function shw {
sed -n '6p' roles/setup_rds/defaults/main.yml
sed -n '18,19p' roles/forum/defaults/main.yml
sed -n '30p' roles/forum/defaults/main.yml
sed -n '32p' roles/forum/defaults/main.yml
sed -n '14p' roles/certs/defaults/main.yml
sed -n '46p' roles/notifier/defaults/main.yml
sed -n '7p' roles/mongo_2_6/defaults/main.yml
sed -n '27p' roles/edxapp/defaults/main.yml
sed -n '46p' roles/edxapp/defaults/main.yml
sed -n '66p' roles/edxapp/defaults/main.yml
sed -n '90p' roles/edxapp/defaults/main.yml
sed -n '97p' roles/edxapp/defaults/main.yml
sed -n '119p' roles/edxapp/defaults/main.yml
sed -n '255p' roles/edxapp/defaults/main.yml
sed -n '265p' roles/edxapp/defaults/main.yml
sed -n '58p' roles/xqueue/defaults/main.yml

}
# This function  will update new IPs 
# in all relevent places.
function upd {
sed -i "6s/localhost/$RDS/"  roles/setup_rds/defaults/main.yml
sed -i "18s/localhost/$MONGO1/" roles/forum/defaults/main.yml
sed -i "19s/localhost/$MONGO2/" roles/forum/defaults/main.yml
sed -i "30s/localhost/$RABBIT/" roles/forum/defaults/main.yml
sed -i "32s/localhost/$ELASTIC/" roles/forum/defaults/main.yml
sed -i "14s/localhost/$RABBIT/" roles/certs/defaults/main.yml
sed -i "46s/localhost/$MONGO2/" roles/notifier/defaults/main.yml
sed -i "7s/localhost/$MONGO1,$MONGO2/" roles/mongo_2_6/defaults/main.yml
sed -i "27s/PreviewURL/$PREVIEWURL/" roles/edxapp/defaults/main.yml
sed -i "46s/AwsS3StorageBucket/$S3STORAGEBUCKET/" roles/edxapp/defaults/main.yml
sed -i "66s/localhost/$MONGO1,$MONGO2/" roles/edxapp/defaults/main.yml
sed -i "90s/localhost/$RDS/" roles/edxapp/defaults/main.yml
sed -i "97s/localhost/$RABBIT/" roles/edxapp/defaults/main.yml
sed -i "119s/localhost/$MONGO2/" roles/edxapp/defaults/main.yml
sed -i "255s/SiteName/$DOMAIN/" roles/edxapp/defaults/main.yml
sed -i "265s/localhost/$RABBIT/" roles/edxapp/defaults/main.yml
sed -i "58s/localhost/$RDS/" roles/xqueue/defaults/main.yml
sed -i "s/unizin.com/example.com/" roles/edxapp/defaults/main.yml

echo "export RDS=$RDS" >> ~/.bashrc
echo "export APP=$APP" >> ~/.bashrc
echo "export MONGO1=$MONGO1" >> ~/.bashrc
echo "export MONGO2=$MONGO2" >> ~/.bashrc
echo "export ELASTIC=$ELASTIC" >> ~/.bashrc
echo "export RABBIT=$RABBIT" >> ~/.bashrc
source ~/.bashrc

}

if [ "$1" = "update" ]
then
  shw
  upd
  echo
  echo "Updated settings:"
  echo
  shw
else
  ./provision_resources.sh $1
fi

