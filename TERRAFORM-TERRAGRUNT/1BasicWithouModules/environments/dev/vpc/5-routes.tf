resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id // Route all traffic to NAT gateway
  }
  tags = {
    Name = "dev-private-rt"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id // Route all traffic to IGW
  }
  tags = {
    Name = "dev-public-rt"
  }
}

// SUBNET ASSOCIATIONS
resource "aws_route_table_association" "private_eu_west_2a" {
  subnet_id      = aws_subnet.private_eu_west_2a.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "private_eu_west_2b" {
  subnet_id      = aws_subnet.private_eu_west_2b.id
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table_association" "public_eu_west_2a" {
  subnet_id      = aws_subnet.public_eu_west_2a.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "public_eu_west_2b" {
  subnet_id      = aws_subnet.public_eu_west_2b.id
  route_table_id = aws_route_table.public_rt.id
}