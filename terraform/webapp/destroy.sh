env=qa

terraform destroy -var-file=terraform-${env}.tfvars --auto-approve