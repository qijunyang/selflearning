
env=qa

terraform --version
terraform fmt --recursive
terraform init -reconfigure -upgrade -backend-config="config.s3.tfbackend-${env}"
terraform plan -var-file=terraform-${env}.tfvars
terraform apply -var-file=terraform-${env}.tfvars --auto-approve