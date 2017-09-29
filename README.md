## Open edX deployment in AWS

#### Instructions for cloning the Unizin `unizin-open-edx` repo
- Perform the following steps:
  - `cd /var/tmp`
  - `git clone https://github.com/michaelsteiner19/open-edx-configuration.git`
  - `cd open-edx-configuration`
    - Our Open edX deployments require fork-specific branches of the Open edX `configuration` repo
      - Such branches of this repo will have names such as `ficus.4`
        - Here `ficus.4` is the 4th point release of Open edX release `ficus`
        - This branch contains fairly substantial changes from the corresponding Open edX point release branch
    - Check out the appropriate branch of the `open-edx-configuration` repo, for instance:
      - `git checkout `ficus.4`
    - Typically, deployments will use the latest available fork branch derived from an Open edX point release

#### Create Open edX base Amazon Machine Image (AMI)

- Launch an EC2 instance from a base Ubuntu 16.04 AMI
  - Accept default settings except as noted below
  - Add a __Name__ tag with value __openedx-build__
  - Configure __Security Group__:
    - Inbound: allow __ssh access only__
    - Outbound: allow all traffic on all ports
  - Add an EC2 key pair __openedx-staging__
    - Download `openedx-staging.pem`
- ssh into __openedx-build__
- Clone the Unizin Open edX repo to `/var/tmp/open-edx-configuration`
  - Check out the appropriate branch of the `configuration` submodule (currently `ficus.4`)
    - `git checkout ficus.4`
  - Run `./install_package_dependencies.sh` to install required packages and dependencies
    - Required Python modules are specified in [requirements.txt][1]
- Create AMI named `openedx-base` from the __openedx-build__ EC2 instance 
  - This AMI will be used as base for all EC2 Open edX server instances

#### Create Open edX build server base Amazon Machine Image (AMI)

- On __openedx-build__ server, perform the following additional setup:
  - Create `/etc/ansible/hosts` file as described [here][2]
    - This simplifies `ansible-playbook` commands that execute on `localhost`
      - It eliminates the need for such commands to specify `-i "localhost,"` and `-c local`
  - Create directory `/home/ubuntu/downloads`
  - Download Oracle JDK tarball `jdk-8u65-linux-x64.tar.gz` and copy it to to __openedx-build__ (use `scp`)
    - use `/home/ubuntu/downloads/` as destination path for scp command
  - Copy the `openedx-staging.pem` private key file to __openedx-build__ (use `scp`)
    - use `/home/ubuntu/` as destination path for scp command
- Create AMI named `openedx-base-build` from the __openedx-build__ EC2 instance
  - This will be used as base AMI for build servers of Open edX instances

#### Build Open edX AWS CloudFormation stacks

Note: Substantial work has gone into simplifiying these steps, the simplified steps will be put in place shortly.

- There are three separate sets of Open edX AWS CloudFormation stacks:
  - build stack (build server security group and ec2 instance)
  - base stacks (IAM user and S3 buckets)
  - main Open edX stack
    - Security Groups
    - MySQL RDS
    - Data servers
    - App server and Elastic Load Balancer
- ssh into appropriate build server
  - __openedx-build__ server for build stack and base stacks
  - __openedx-\<university short name\>-build__ server for remaining stacks
- Set AWS access key environment variables:
  - Use access key and secret for IAM user __openedx-build-user__
    - `export AWS_ACCESS_KEY_ID=...`
    - `export AWS_SECRET_ACCESS_KEY=...`
  - If building in AWS prod account also set the environment variable:
    - `export AWS_MFA_SERIAL=arn:aws:iam::489515563883:mfa/<user name>`
 - If need be, pull current sources for the `unizin-open-edx` repo and/or its `configuration` submodule from GitHub
  - Change directory to `/var/tmp/unizin-open-edx/configuration/playbook`
- Deploying Open edX to the Unizin AWS prod account requires MFA
  - Copy the `mfa_wrap.sh` script into this directory (from the root of the Unizin `ansible` repo in GitHub)
  - Run the command `. ./mfa_wrap.sh`
- The ansible playbook to run is:
  - `create_build_stack` for build stack
  - `create_base_stacks` for base stacks
  - `create_stacks` for remaining Open edX stacks
- Run ansible playbook:
  - `ansible-playbook -vvvv <playbook>.yml -e env=<dev or prod> -e short_name=<university short name>` 
    - If deploying to the Unizin AWS prod account, this command needs to be preceded by `mfa_wrap <MFA code>`
    - The create_stacks playbook requires the additional command line argument `--private-key=/home/ubuntu/openedx-staging.pem`

#### Provision RDS and EC2 instances

- The `create_stacks` playbook creates/updates the shell script `/home/ubuntu/env.sh`.
  - Source this script to set a number of environment variables including:
    - `APP`
    - `MONGO1`
    - `MONGO2`
    - `COMMON`
    - `ELASTIC`
    - `RABBIT`
- The remaining deployment steps are performed via the `provision_resources.sh` shell script:
  - provision MySQL RDS
    - `./provision_resources.sh rds`
  - provision EC2 instance for primary MongoDB database
    - `./provision_resources.sh mongo1`
  - provision EC2 instance for secondary MongoDB database
    - `./provision_resources.sh mongo2`
  - provision common EC2 instance for Elastic, RabbitMQ, and XQueue
    - `./provision_resources.sh common`
  - provision primary mongo EC2 instance for discussion forums
    - `./provision_resources.sh forums`
  - provision EC2 instance for Open edX LMS and CMS
    - `./provision_resources.sh app`

[1]: https://github.com/michaelsteiner19/open-edx-configuration/blob/improved_automation/requirements.txt
[2]: http://ansible.pickle.io/post/86598332429/running-ansible-playbook-in-localhost

