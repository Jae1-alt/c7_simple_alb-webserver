
/* # outputs the public IPv4 address of the instance
output "first7_public_ip" {
  value = [
    for instance in aws_instance.first7 : "The ${instance.tags_all.Name} public IP: http://${instance.public_ip}"
  ]
}


# Output the public DNS address of the instance
output "first7_public_dns" {
  value = [
    for instance in aws_instance.first7 : "The ${instance.tags_all.Name} public DNS: http://${instance.public_dns}"
  ]
}
 */

# Output the public DNS address of the ALB
output "alb_public_dns" {
  value = "The alb public public DNS: http://${aws_lb.test.dns_name}"
}
