# Table of contents

- [Table of contents](#table-of-contents)
- [Description](#description)


# Description
Use this terraform code to create a easy cloud9 environment for your projects

# How to run
## Prerequisites
You need to have:
    - Access with privileges to create VPC, Subnets,Internet gateway and Cloud9 environments into an AWS Account
    - AWS CLI installed and configures
    - Terraform installed
  
# 1. Create a bucket to store the terraform state
After create a bucket, fill (backend.tf)[backend.tf] with the correct bucket name

# 2. Set the correct VPC cidr block and other parameters
fill the locals on (main.tf)[main.tf] with the correct VPC CIDR Block, project and environment

# 3. Run the terraform
```bash
terraform init
terraform plan -out tfplan #check the resources that will be created
terraform apply tfplan
```