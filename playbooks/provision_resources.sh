# All these commands will be executed from Login Server which has all the repository  
# and will be working as a controlling host.


# You can run individual roles with the help of "run_role.yml" 
# simply give role name in the arguments and it will run that specific role 
# -i is used to define server IP on which to run the role
# the variables are exported in .bashrc file for current user

private_key_path=/home/ubuntu/openedx-staging.pem

VALID_TARGETS='(mongo1|mongo2|rds|common|app|forums)'
function show_usage {
  echo "Usage:"
  echo "provision_resource.sh $VALID_TARGETS"
  echo
}

if [ "$1" = "rds" ]
then
  # Create ll required users and databases in previously launched RDS
  ansible-playbook run_role.yml -e role=setup_rds | tee ansible.out
elif [ "$1" = "mongo1" ]
then
  # Install mongoDB on secondary node (configured without replication)
  ansible-playbook -i "$MONGO1," run_role.yml -e role=mongo_2_6 -e MONGO_CLUSTERED=false -vvv --private-key=$private_key_path | tee ansible.out
elif [ "$1" = "mongo2" ]
then
  # Install mongoDB on primary node and initialize replicaset
  ansible-playbook -i "$MONGO2," run_role.yml -e role=mongo_2_6 -e MONGO_CLUSTERED=true -vvv --private-key=$private_key_path | tee ansible.out
elif [ "$1" = "common" ]
then
  scp -i ~/openedx-staging.pem /home/ubuntu/downloads/jdk-8u65-linux-x64.tar.gz "ubuntu@$RABBIT:/var/tmp/"
  # Install RabbitMQ, ElasticSearch, Xqueue
  ansible-playbook -i "$RABBIT," rabbit.yml -vvv --private-key=$private_key_path | tee ansible.out
elif [ "$1" = "forums" ]
then
  # Deploy forums and forum site this playbook
  ansible-playbook -i "$MONGO1," forum.yml -vvv --private-key=$private_key_path | tee ansible.out
elif [ "$1" = "app" ]
then
  # Run main ansible playbook for edX app deployment
  ansible-playbook -i "$APP," edx-stateless.yml -vvv --private-key=$private_key_path | tee ansible.out
else
  echo
  echo "Invalid command line parameter '$1'"
  echo
  show_usage
fi

