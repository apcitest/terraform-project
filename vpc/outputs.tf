output "vpc_id" {
 value = aws_vpc.apci_main_vpc.id
}

output "frontend_subnet_az_1a_id" {
  value = aws_subnet.frontend_subnet_az_1a.id
}

output "frontend_subnet_az_1b_id" {
  value = aws_subnet.frontend_subnet_az_1b.id
}

output "backend_subnet_az_1a_id" {
  value = aws_subnet.backend_subnet_az_1a.id
}

output "backend_subnet_az_1b_id" {
  value = aws_subnet.backend_subnet_az_1b.id
}

output "db_subnet_az_1a_id" {
  value = aws_subnet.db_subnet_az_1a.id
}

output "db_subnet_az_1b_id" {
  value = aws_subnet.db_subnet_az_1b.id
}