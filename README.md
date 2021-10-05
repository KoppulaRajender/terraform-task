## Steps to use

* clone the repo
* go to codescan-terraform folder
  ```shell
  cd codescan-terraform
  ```

* go through the main.tf and change accordingly (change backend config according to you platform)

### Terraform commands

1. init
```shell
terraform init
```

2. plan
```shell
terraform plan -var-file="../tfvars/dev.tfvars"
```

3. apply
```shell
terraform apply -var-file="../tfvars/dev.tfvars"
```