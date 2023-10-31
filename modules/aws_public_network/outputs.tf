output vpc_id {
    value = aws_vpc.network_vpc.id
}

output subnet_id {
    value = aws_subnet.network_subnet.id
}

output internet_gateway {
    value = aws_internet_gateway.network_vpc_gateway
}