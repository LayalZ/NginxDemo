resource "aws_subnet" "public_subnets" {
  for_each                = local.public_subnets_config
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.value.cidr_block
  availability_zone       = "${var.aws_region}${each.value.az_suffix}"
  map_public_ip_on_launch = true

  tags = merge(local.common_tags, {
    Name = "${var.project_name}-${each.key}"
  })
}

resource "aws_route_table_association" "public_subnet_associations" {
  for_each       = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}