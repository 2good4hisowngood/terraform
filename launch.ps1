terraform plan -var-file="vars.tfvars"
terraform apply -var-file="vars.tfvars" -auto-approve
terraform destroy -var-file="vars.tfvars" -auto-approve