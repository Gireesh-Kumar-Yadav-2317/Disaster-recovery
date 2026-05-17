resource "aws_vpc" "this" {
    cidr_block = var.cidr_block

    enable_dns_support = var.enable_dns_support
    enable_dns_hostnames = var.enable_dns_hostnames

    tags = merge(
        local.common_tags, 
        {
            Name ="${local.name_prefix}-vpc"
        }
    )
  
}

resource "aws_internet_gateway" "igw" {
    vpc_id =aws_vpc.this.id
    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix}-igw"

        }
    )
}

resource "aws_subnet" "public" {
    count = length(local.azs)

    vpc_id = aws_vpc.this.id
    cidr_block = local.public_subnet_cidrs[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = true

    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix} -public-${local.azs[count.index]}"
        }
    )

}


resource "aws_subnet" "private" {
    count = length(local.azs)

    vpc_id = aws_vpc.this.id
    cidr_block = local.private_subnet_cidrs[count.index]
    availability_zone = local.azs[count.index]
    map_public_ip_on_launch = false

    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix} -private-${local.azs[count.index]}"
        }
    )

}


resource "aws_eip" "nat" {
    count = var.enable_nat_gateway ? length(local.azs) : 0
}

resource "aws_nat_gateway" "nat" {

    count = var.enable_nat_gateway ? length(local.azs) : 0

    allocation_id = aws_eip.nat[count.index].id
    subnet_id = aws_subnet.public[count.index].id
    depends_on = [aws_internet_gateway.igw]

    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix}-nat-${local.azs[count.index]}"
        }
    )
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.this.id

    tags = merge(
        local.common_tags,
        {
            Name = "${local.name_prefix}-public-rt"
        }
    )
}

resource "aws_route" "public" {
    route_table_id = aws_route_table.public.id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
}


resource "aws_route_table" "private" {
  count  = length(local.azs)
  vpc_id = aws_vpc.this.id

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-private-rt-${count.index}"
    }
  )
}

resource "aws_route" "private_nat" {
    count = var.enable_nat_gateway ? length(local.azs) : 0

    route_table_id = aws_route_table.private[count.index].id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[count.index].id
}


resource "aws_route_table_association" "public" {
    count = length(local.azs)

    subnet_id = aws_subnet.public[count.index].id
    route_table_id = aws_route_table.public.id
}


resource "aws_route_table_association" "private" {
  count = length(local.azs)

  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private[count.index].id
}