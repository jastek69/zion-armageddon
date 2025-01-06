
resource "aws_ec2_transit_gateway" "tokyo-tgw" {
  description = "tg-tokyo-database"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "Tokyo Transit Gateway"
  }
}


resource "aws_ec2_transit_gateway" "london-tgw" {
  provider = aws.london
  description = "tg-london-database"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "London Transit Gateway"
  }
}

resource "aws_ec2_transit_gateway" "sao-tgw" {
  provider = aws.saopaulo
  description = "tg-sao-database"
  auto_accept_shared_attachments = "enable"
  tags = {
    Name = "Sao Paulo Transit Gateway"
  }
}
