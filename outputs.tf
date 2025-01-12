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

output "ca_public_ip80" {
  value = aws_instance.ec2-cali-80.public_ip
}

output "hk_public_ip80" {
  value = aws_instance.ec2-hongkong-80.public_ip
}


output "ny_public_ip80" {
  value = aws_instance.ec2-ny-80.public_ip
}

output "aus_public_ip80" {
  value = aws_instance.ec2-aus-80.public_ip
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

output "ca_tgw_id" {
  value = aws_ec2_transit_gateway.ca-tgw.id
}

output "hk_tgw_id" {
  value = aws_ec2_transit_gateway.hk-tgw.id
}


output "ny_tgw_id" {
  value = aws_ec2_transit_gateway.ny-tgw.id
}


output "aus_tgw_id" {
  value = aws_ec2_transit_gateway.aus-tgw.id
}
