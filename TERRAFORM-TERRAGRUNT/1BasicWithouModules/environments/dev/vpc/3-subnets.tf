// Creating 2 private and 2 public subnets in eu-west-2a and eu-west-2b availability zones
// Because EKS needs atleast 2 subnets in a VPC
// Subnets have to be tagged for EKS to work properly
resource "aws_subnet" "private_eu_west_2a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"
  tags = {
    "Name"                            = "dev-private-eu-west-2a"
    "kubernetes.io/role/internal-elb" = "1"     // can use private subnet to create private loadbalancers
    "kubernetes.io/cluster/dev-demo"  = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }
}

resource "aws_subnet" "private_eu_west_2b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"
  tags = {
    "Name"                            = "dev-private-eu-west-2b"
    "kubernetes.io/role/internal-elb" = "1"     // can use private subnet to create private loadbalancers
    "kubernetes.io/cluster/dev-demo"  = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }
}

resource "aws_subnet" "public_eu_west_2a" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "eu-west-2a"
  map_public_ip_on_launch = true // Assign public IP to instances in this subnet

  tags = {
    "Name"                           = "dev-public-eu-west-2a"
    "kubernetes.io/role/elb"         = "1"     // can use private subnet to create public loadbalancers
    "kubernetes.io/cluster/dev-demo" = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }
}

resource "aws_subnet" "public_eu_west_2b" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "eu-west-2b"
  map_public_ip_on_launch = true // Assign public IP to instances in this subnet

  tags = {
    "Name"                           = "dev-public-eu-west-2b"
    "kubernetes.io/role/elb"         = "1"     // can use private subnet to create public loadbalancers
    "kubernetes.io/cluster/dev-demo" = "owned" // cluster dev-demo can use private subnet to create loadbalancersm can be owned or shared
  }
}