output "cloud9_env" {
  value = aws_cloud9_environment_ec2.this[*].id
}

output "cloud9_url" {
  value = format("https://%s.console.aws.amazon.com/cloud9/ide/%s", var.region, aws_cloud9_environment_ec2.this[0].id)
}