output "vpc_id" {
    value = aws_vpc.this.id

}

output "public_subnet_ids" {
    value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
    value = aws_subnet.private[*].id
}


output "nat_gateway_ids" {
    value = aws_nat_gateway.nat[*].id
}

output "route_table_public_id" {
    value = aws_route_table.public.id
}

output "route_table_private_id" {
    value = aws_route_table.private[*].id
}

output "internet_gateway_id" {
    value = aws_internet_gateway.igw.id
}
output "availability_zones" {
    value = local.azs
}

