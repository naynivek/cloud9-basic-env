resource "aws_cloud9_environment_ec2" "this" {
  count         = length(module.vpc.subnet)
  name          = "training"
  instance_type = "t2.micro"
  image_id      = "amazonlinux-2-x86_64"
  subnet_id     = module.vpc.subnet[count.index].id
}

module "vpc" {
  source      = "./modules/vpc"
  cidr_block  = local.cidr_block
  project     = local.project
  environment = local.environment
}

locals {
  cidr_block  = "10.0.0.0/24"
  project     = "training"
  environment = "dev"
}