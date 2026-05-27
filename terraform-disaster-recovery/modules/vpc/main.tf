resource "aws_vpc" "this" {

    cidr_block =  var.cidr_block

    enable_dns_hostnames = var.enable_dns_hostnames
    enable_dns_support = var.enable_dns_support

    tags = merge(local.common_tags,
    {
        Name = "${local.name_prefix}-vpc"
    })

    lifecycle {
      prevent_destroy = false
    }
  
}


resource "aws_internet_gateway" "igw" {

    vpc_id = aws_vpc.this.id

    tags = merge(local.common_tags,
    {
        Name = "${local.name_prefix}-igw"
    })

  
}


resource "aws_subnet" "public" {

    for_each = local.public_subnets

    vpc_id = aws_vpc.this.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = true

     tags = merge(local.common_tags,
    {
        Name = "${local.name_prefix}-public-${each.value.az}"
        Type = "Public"
    })
}


resource "aws_subnet" "private" {

    for_each = local.private_subnets

    vpc_id = aws_vpc.this.id
    cidr_block = each.value.cidr
    availability_zone = each.value.az
    map_public_ip_on_launch = false

     tags = merge(local.common_tags,
    {
        Name = "${local.name_prefix}-private-${each.value.az}"
        Type = "private"
    })
}



resource "aws_eip" "nat" {

    for_each = var.enable_nat_gateway ? local.public_subnets : {}

    domain = "vpc"
    tags = merge(
        local.common_tags,
    {
        Name = "${local.name_prefix}-eip-${each.key}"
    })

  
}



resource "aws_nat_gateway" "this" {

    for_each = var.enable_nat_gateway ? local.public_subnets : {}

    allocation_id = aws_eip.nat[each.key].id

    subnet_id = aws_subnet.public[each.key].id

    depends_on = [ aws_internet_gateway.igw ]

    tags = merge(
        local.common_tags,
    {
        Name = "${local.name_prefix}-nat-${each.key}"
    })

  
}


resource "aws_route_table" "public" {

    vpc_id =aws_vpc.this.id

    tags =merge (
        local.common_tags,
        {
            Name = "${local.name_prefix}-public-rt"
        }
    )
  
}


resource "aws_route" "public_internet_access" {

    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id

  
}


resource "aws_route_table" "private" {
    for_each = local.private_subnets
    vpc_id =aws_vpc.this.id

    tags =merge (
        local.common_tags,
        {
            Name = "${local.name_prefix}-private-rt-${each.key}"
        }
    )
  
}


resource "aws_route" "private_nat" {
    for_each = var.enable_nat_gateway ? local.private_subnets : {}
    route_table_id = aws_route_table.private[each.key].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.this[each.key].id

  
}

resource "aws_route_table_association" "public" {

  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {

  for_each = local.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id
}

