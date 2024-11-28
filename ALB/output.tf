output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  description = "The zone ID of the ALB"
  value       = aws_lb.alb.zone_id
}
output "alb_arn" {
  description = "The ARN of the Application Load Balancer"
  value       = aws_lb.alb.arn
}

output "alb_dns_name" {
  description = "The DNS name of the Application Load Balancer"
  value       = aws_lb.alb.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.tg.arn
}

output "listener_http_arn" {
  description = "The ARN of the HTTP listener"
  value       = aws_lb_listener.http[0].arn
}

output "listener_https_arn" {
  description = "The ARN of the HTTPS listener"
  value       = aws_lb_listener.https[0].arn
}
output "alb_default_sg_id" {
  description = "The ID of the default security group for the ALB"
  value       = aws_security_group.default_sg[0].id

}
