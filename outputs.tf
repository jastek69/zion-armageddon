# Output the public IP address of the instance (optional)
output "tokyo_public_ip80" {
  value = aws_instance.ec2-tokyo-80.public_ip
}

output "tokyo_public_ip443" {
  value = aws_instance.ec2-tokyo-443.public_ip
}

output "london_public_ip80" {
  value = aws_instance.ec2-london-80.public_ip
}

output "sao_public_ip80" {
  value = aws_instance.ec2-saopaulo-80.public_ip
}

output "tokyo_tgw_id" {
  value = aws_ec2_transit_gateway.tokyo-tgw.id
}

output "london_tgw_id" {
  value = aws_ec2_transit_gateway.london-tgw.id
}

output "sao_tgw_id" {
  value = aws_ec2_transit_gateway.sao-tgw.id
}
