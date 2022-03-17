
#For example, instead of having to manually poke around the EC2 console to find the IP address of your server, you can provide the IP address as an output variable:
#    output "public_ip" {
#      value       = aws_instance.example.public_ip
#      description = "The public IP address of the web server"
#}
#$ terraform output public_ip
#    54.174.13.5

output "alb_dns_name" {
  value       = aws_lb.example.dns_name
  description = "The domain name of the load balancer"
}

output "asg_name" {
  value       = aws_autoscaling_group.example.name
  description = "The name of the Auto Scaling Group"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "The ID of the Security Group attached to the load balancer"
}

