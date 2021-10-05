## Steps to use

* clone the repo
* go to codescan-terraform folder
  ```shell
  cd codescan-terraform
  ```

* go through the main.tf and change accordingly (change backend config according to you platform)

## Terraform commands

* init
terraform init

* plan
terraform plan -var-file="../tfvars/dev.tfvars"

* apply
terraform apply -var-file="../tfvars/dev.tfvars"
