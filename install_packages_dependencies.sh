#
# Run these commands in a fresh Ubuntu 16.04 OS to install packages required for OpenEdX deployment.
#


sudo apt-get update
# Packages from apt-get repository
sudo apt-get install -y build-essential software-properties-common python-software-properties curl git-core libxml2-dev libxslt1-dev libfreetype6-dev python-pip python-apt python-dev libxmlsec1-dev swig libmysqlclient-dev mysql-client-core-5.7

# Packages from Python PIP
sudo pip install --upgrade pip==8.1.2

sudo pip install --upgrade virtualenv
# Note: don't add virtualenv version or you'll face compilation error 

sudo pip install setuptools --upgrade

sudo pip install -r ./requirements.txt

# After the packages are installed make sure to create an AWS MAchine Image (AMI)
# from the server to launch new Open edX servers from.

