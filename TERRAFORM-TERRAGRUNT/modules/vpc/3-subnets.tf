resource "aws_subnet" "private" {
  count             = length(var.private_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    { Name = "${var.env}-private-${var.azs[count.index]}" }, var.private_subnet_tags
  )
}

resource "aws_subnet" "public" {
  count             = length(var.public_subnets)
  vpc_id            = aws_vpc.this.id
  cidr_block        = var.public_subnets[count.index]
  availability_zone = var.azs[count.index]

  tags = merge(
    { Name = "${var.env}-public-${var.azs[count.index]}" }, 
    var.public_subnet_tags
  )
}

// merge will do the following
// Name = env-public-eu-west-2a{az[1]} will be merged with additional tags passed in terragrunt.hcl file for vpc
// Subnets will be tagged as  
/* 
  Name = env-public-eu-west-2a
  "kubernetes.io/role/internal-elb" = "1"     
  "kubernetes.io/cluster/dev-demo"  = "owned
*/
