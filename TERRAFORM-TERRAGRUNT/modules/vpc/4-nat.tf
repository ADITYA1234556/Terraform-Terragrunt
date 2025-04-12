// ALlocate static public IP for Nat Gateway
resource "aws_eip" "this" {
  vpc = true

  tags = {
    Name = "${var.env}-nat-eip"
  }

}

resource "aws_nat_gateway" "this" {
  allocation_id = aws_eip.this.id
  subnet_id     = aws_subnet.public[0].id // NAT gateway should be in public subnet, subnet 1

  tags = {
    Name = "${var.env}-nat-gateway"
  }

  depends_on = [aws_internet_gateway.this] // NAT gateway should be created after IGW is created
}