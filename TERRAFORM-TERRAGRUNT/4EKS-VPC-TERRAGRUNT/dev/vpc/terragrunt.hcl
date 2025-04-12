terraform {
    source = "../../../modules/vpc"
    // source = "git@github.com:ADITYA1234556/Terraform-Terragrunt.git//modules/vpc?ref=kuebertes-modules"

}

include "root" {
    path = find_in_parent_folders()
}

include "env" {
    path = find_in_parent_folders("env.hcl")
    expose = true // Inserted config will be parsed and made available as a variable
    merge_strategy ="no_merge"
}

// Passing inputs to vpc module 
inputs = {
  env = include.env.locals.env
  azs = ["eu-west-2a", "eu-west-2b" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"     // can use private subnet to create private loadbalancers
    "kubernetes.io/cluster/dev-demo"  = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"     // can use public subnet to create public loadbalancers
    "kubernetes.io/cluster/dev-demo"  = "owned" // cluster dev-demo can use public subnet to create loadbalancersm can be owned or shared
  }

}