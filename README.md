# Introduction

This project contains code for provisioning infrastructure for building, storing artifacts and deploying
"encoding" and "google-online-boutique" projects. The entire infratructure is on aws.

# EC2 ssh key pairs

Key pairs for ssh access to EC2 instances must be created either through aws cli or in web ui.
AWS cli command:    aws ec2 create-key-pair --key-name <key-pair-name>
This command generates .pem file with private key. Store it somewhere locally (~./ssh for example) and
change permissions (chmod 400 /path/to/key.pem). This key must exist in AWS-EC2/Network & Security/Key pairs
befor creating EC2 instances - this "master" key is associated with an EC2 instance during its creation.

# Switch between regions

Terraform state files are stored in S3 bucket "ttt-tfstates" in following locations:

Vars config file                S3 tfstate path

config-eu-central-1             eu-central-1/terraform.tftsate
config-eu-west-1                eu-west-1/terraform.tftsate

S3 bucket itself is deployed in eu-central-1 region. This is just where the bucket with state files is physically located and has nothing to do with configuring the rest of tf configurations to deploy resources to another region.

How to configure terraform to work with eu-west-1 region:

- Set backend.key to "eu-west-1/terraform.tfstate":

  backend "s3" {
    bucket = "ttt-tfstates"
    key    = "eu-west-1/terraform.tfstate"
    region = "eu-central-1"
  }

How to configure terraform to work with eu-central-1 region:

- Set backend.key to "eu-west-1/terraform.tfstate":

  backend "s3" {
    bucket = "ttt-tfstates"
    key    = "eu-central-1/terraform.tfstate"
    region = "eu-central-1"
  }

backend.region always remains "eu-central-1" because that's where the bucket is!

After setting backend.key, run terraform init to let terraform know with which state file it needs to work with.

To work with "eu-west-1" resources, use -var-file=config-eu-west-1 with terraform plan/apply commands.

To work with "eu-central-1" resources, use -var-file=config-eu-central-1 with terraform plan/apply commands.

Important: always run "terraform init" after making changes to the backend.key value!

State files in S3 bucket are versioned, so that's how you can recover if a state file somehow gets messed up.

# Connect kubectl to EKS cluster

Prerequisites: AWS CLI, kubectl and aws-iam-authenticator installed

aws eks update-kubeconfig --name <cluster_name> --region <cluster_region>

~/.kube/config will be updated after running this command. This connects kubectl to the cluster.

To test: kubectl get node -> should list all cluster nodes