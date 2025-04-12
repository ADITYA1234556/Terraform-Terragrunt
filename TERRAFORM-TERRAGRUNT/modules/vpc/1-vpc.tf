// If only one resource of a type is created it should be named as "this".
resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr_block

  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.env}-main"
  }
}