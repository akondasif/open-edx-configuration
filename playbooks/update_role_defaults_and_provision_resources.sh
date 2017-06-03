rds=openedx-rds-unizin2.cglg2lgriogm.us-east-1.rds.amazonaws.com
domain=openedx-unizin2.testing.unizin.org
app=172.31.2.238
pmongo=172.31.1.254
smongo=172.31.6.130
elastic=172.31.0.70
rabbit=172.31.0.70
# We need to modify these values in files 

# rds
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
sed -n '66p' roles/edxapp/defaults/main.yml
sed -n '90p' roles/edxapp/defaults/main.yml
sed -n '97p' roles/edxapp/defaults/main.yml
sed -n '119p' roles/edxapp/defaults/main.yml
sed -n '255p' roles/edxapp/defaults/main.yml
sed -n '257p' roles/edxapp/defaults/main.yml
sed -n '265p' roles/edxapp/defaults/main.yml
sed -n '58p' roles/xqueue/defaults/main.yml

}
# This function  will update new IPs 
# in all relevent places.
function upd {
sed -i "6s/localhost/$rds/"  roles/setup_rds/defaults/main.yml
sed -i "18s/localhost/$pmongo/" roles/forum/defaults/main.yml
sed -i "19s/localhost/$smongo/" roles/forum/defaults/main.yml
sed -i "30s/localhost/$rabbit/" roles/forum/defaults/main.yml
sed -i "32s/localhost/$elastic/" roles/forum/defaults/main.yml
sed -i "14s/localhost/$rabbit/" roles/certs/defaults/main.yml
sed -i "46s/localhost/$smongo/" roles/notifier/defaults/main.yml
sed -i "7s/localhost/$pmongo,$smongo/" roles/mongo_2_6/defaults/main.yml
sed -i "66s/localhost/$pmongo,$smongo/" roles/edxapp/defaults/main.yml
sed -i "90s/localhost/$rds/" roles/edxapp/defaults/main.yml
sed -i "97s/localhost/$rabbit/" roles/edxapp/defaults/main.yml
sed -i "119s/localhost/$smongo/" roles/edxapp/defaults/main.yml
sed -i "255s/localhost/$domain/" roles/edxapp/defaults/main.yml
sed -i "257s/localhost/$domain/" roles/edxapp/defaults/main.yml
sed -i "265s/localhost/$rabbit/" roles/edxapp/defaults/main.yml
sed -i "58s/localhost/$rds/" roles/xqueue/defaults/main.yml
sed -i "s/unizin.com/example.com/" roles/edxapp/defaults/main.yml

echo "export rds=$rds" >> ~/.bashrc
echo "export app=$app" >> ~/.bashrc
echo "export pmongo=$pmongo" >> ~/.bashrc
echo "export smongo=$smongo" >> ~/.bashrc
echo "export elastic=$elastic" >> ~/.bashrc
echo "export rabbit=$rabbit" >> ~/.bashrc
source ~/.bashrc

}

if [ "$1" = "update" ]
then
  shw

  read -p "Update IPs (y/n)?" choice
  case "$choice" in 
    y|Y ) echo "yes";upd;shw;; 
    n|N ) echo "no";;
    * ) echo "invalid";;
  esac
else
  ./provision_resources.sh $1
fi

