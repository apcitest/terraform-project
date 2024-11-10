output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = [aws_lb_target_group.target_group.arn]
}

output "alb_dns_name" {
  value = aws_lb.apci_alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.apci_alb.zone_id
}