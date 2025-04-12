// ALlocate static public IP for Nat Gateway
resource "aws_eip" "nat_eip" {
  vpc = true

  tags = {
    Name = "dev-nat-eip"
  }

}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_eu_west_2a.id // NAT gateway should be in public subnet, subnet 1

  tags = {
    Name = "dev-nat-gateway"
  }

  depends_on = [aws_internet_gateway.igw] // NAT gateway should be created after IGW is created
}