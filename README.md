# Introduction

This project contains code for provisioning infrastructure for building, storing artifacts and deploying
"encoding" and "google-online-boutique" projects. The entire infratructure is on aws.

# EC2 ssh key pairs

Key pairs for ssh access to EC2 instances must be created either through aws cli or in web ui.
AWS cli command:    aws ec2 create-key-pair --key-name <key-pair-name>
This command generates .pem file with private key. Store it somewhere locally (~./ssh for example) and
change permissions (chmod 400 /path/to/key.pem). This key must exist in AWS-EC2/Network & Security/Key pairs
befor creating EC2 instances - this "master" key is associated with an EC2 instance during its creation.