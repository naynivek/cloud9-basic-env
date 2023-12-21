data "aws_instance" "cloud9_instance" {
  count = length(aws_cloud9_environment_ec2.this)
  filter {
    name = "tag:aws:cloud9:environment"
    values = [
    aws_cloud9_environment_ec2.this[count.index].id]
  }
}
