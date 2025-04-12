# TERRAGRUN ACROSS MULTIPLE MODULES

## Terraform module for VPC
- Inside the root directory. create a folder for VPC which will pass values to VPC module 
## Terraform module for EKS
- Inside the root directory. create a folder for EKS which will pass values to EKS module 

## Terragrunt execution
- From the root directory where we have folders for VPC and EKS, and root terragrunt.hcl we can run the command 
```terraform
terragrunt run-all init
terragrunt run-all fmt
terragrunt run-all validate
terragrunt run-all plan
terragrunt run-all apply
```

## BENEFITS
- Terragrunt support dependency across modules.
- A output value from one module can be passed as input to another module
- For example, An output from vpc module giving the private subnet IDs can be passed as input variable to EKS   
