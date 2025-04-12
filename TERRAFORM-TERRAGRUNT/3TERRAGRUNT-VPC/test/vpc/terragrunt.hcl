terraform {
    source = "../../vpc-modules/vpc"
}

include "root" {
    path = find_in_parent_folders()
}

inputs = {
    env = "test"
  azs = ["eu-west-2a", "eu-west-2b" ]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"     // can use private subnet to create private loadbalancers
    "kubernetes.io/cluster/test-demo"  = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }

    public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"     // can use public subnet to create public loadbalancers
    "kubernetes.io/cluster/test-demo"  = "owned" // cluster dev-demo can use public subnet to create loadbalancersm can be owned or shared
  }

}

