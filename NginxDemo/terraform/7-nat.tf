resource "aws_eip" "nat_eip" {
  domain = "vpc"
  tags = merge(local.common_tags, {
    Name = local.nat_eip_name
  })
}

resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnets["public_subnet_1"].id # NAT Gateway assigned to a public subnet

  tags = merge(local.common_tags, {
    Name = local.nat_gateway_name
  })
  depends_on = [aws_internet_gateway.gw]
}