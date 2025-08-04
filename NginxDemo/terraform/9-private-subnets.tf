resource "aws_subnet" "private_subnets" {
  for_each          = local.private_subnets_config
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.value.cidr_block
  availability_zone = "${var.aws_region}${each.value.az_suffix}"

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
  })
}

resource "aws_route_table_association" "private_subnet_associations" {
  for_each       = aws_subnet.private_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt.id
}
