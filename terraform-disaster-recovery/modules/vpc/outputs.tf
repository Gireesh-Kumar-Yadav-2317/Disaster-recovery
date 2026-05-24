

output "vpc_id" {

  description = "VPC ID"

  value = aws_vpc.this.id
}

output "vpc_cidr_block" {

  description = "VPC CIDR block"

  value = aws_vpc.this.cidr_block
}


output "internet_gateway_id" {

  description = "Internet Gateway ID"

  value = aws_internet_gateway.igw.id
}

output "public_subnet_ids" {

  description = "Public subnet IDs"

  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

output "public_subnet_cidrs" {

  description = "Public subnet CIDRs"

  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.cidr_block
  }
}

output "private_subnet_ids" {

  description = "Private subnet IDs"

  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}

output "private_subnet_cidrs" {

  description = "Private subnet CIDRs"

  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.cidr_block
  }
}


output "public_route_table_id" {

  description = "Public route table ID"

  value = aws_route_table.public.id
}

output "private_route_table_ids" {

  description = "Private route table IDs"

  value = {
    for az, rt in aws_route_table.private :
    az => rt.id
  }
}


output "nat_gateway_ids" {

  description = "NAT Gateway IDs"

  value = {
    for az, nat in aws_nat_gateway.this :
    az => nat.id
  }
}


output "nat_eip_public_ips" {

  description = "Public IPs of NAT Gateways"

  value = {
    for az, eip in aws_eip.nat :
    az => eip.public_ip
  }
}

output "availability_zones" {

  description = "Configured Availability Zones"

  value = local.azs
}


output "vpc_summary" {

  description = "Complete VPC deployment summary"

  value = {
    vpc_id              = aws_vpc.this.id
    vpc_cidr            = aws_vpc.this.cidr_block
    public_subnets      = values(aws_subnet.public)[*].id
    private_subnets     = values(aws_subnet.private)[*].id
    nat_gateways        = values(aws_nat_gateway.this)[*].id
    availability_zones  = local.azs
  }
}