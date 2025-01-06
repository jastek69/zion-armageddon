
/*
 resource "aws_ec2_transit_gateway" "tokyo_tgw" {
    description = "tokyo transit gateway"
    provider = aws

    tags = {
      Name = "main tokyo transit gateway"
    }
  }

  resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_tga" {
    subnet_ids = [aws_subnet.TOKYO_SUBNET.id]
    transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id
    vpc_id = aws_vpc.TOKYO_VPC.id
    provider = aws

    tags = {
      Name = "main tokyo londonaas tgw attachment"
    }
  }

  data "aws_ec2_transit_gateway_route_table" "tokyo_tgrt" {
    provider = aws

    filter {
      name   = "default-association-route-table"
      values = ["true"]
    }

    filter {
      name   = "transit-gateway-id"
      values = [aws_ec2_transit_gateway.tokyo_tgw.id]
    }

    tags = {
      Name = "main tgw tokyo route table"
    }
  }

  resource "aws_ec2_transit_gateway_route" "tokyo_tgr" {
    #destination_cidr_block = var.staging_private_subnet_cidr
    destination_cidr_block = "10.240.0.0/24" # Route to private subnet
    transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo_tgrt.id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tokyo_tga.id
    provider = aws
  }

  resource "aws_ec2_transit_gateway_peering_attachment" "tokyo_tgpa" {
    provider = aws
    peer_transit_gateway_id = aws_ec2_transit_gateway.london_tgw.id
    transit_gateway_id = aws_ec2_transit_gateway.tokyo_tgw.id
    # peer_account_id = var.account_id
    #peer_region = var.dr_region
    peer_region = "eu-west-2"

    tags = {
      Name = "main london tgw peering"
    }
  }

## LONDON

resource "aws_ec2_transit_gateway" "london_tgw" {
  provider = aws.london
  description = "london transit gateway"

  tags = {
    Name = "london transit draas gateway"
  }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "london_tga" {
  provider = aws.london
  #subnet_ids = [aws_subnet.staging_private.id]
  subnet_ids = [aws_subnet.LONDON_SUBNET.id]
  transit_gateway_id = aws_ec2_transit_gateway.london_tgw.id
  vpc_id = aws_vpc.LONDON_VPC.id

  tags = {
    Name = "London tgw draas attachment"
  }
}

data "aws_ec2_transit_gateway_route_table" "london_tgrt" {
  provider = aws.london

  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = [aws_ec2_transit_gateway.london_tgw.id]
  }

  tags = {
    Name = "london tgw draas route table"
  }
}

resource "aws_ec2_transit_gateway_route" "london_tgr" {
  provider = aws.london
  #destination_cidr_block = var.main_private_subnet_cidr
  destination_cidr_block = "10.240.0.0/24"
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.london_tgrt.id
  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.london_tga.id
}

data "aws_ec2_transit_gateway_peering_attachment" "london_tgpa" {
  provider = aws.london
  depends_on = [ aws_ec2_transit_gateway_peering_attachment.tokyo_tgpa ]

  filter {
    name = "state"
    values = [ "pendingAcceptance" ]
  }

  # Only the second accepter/peer transit gateway is called from the peering attachment.
  filter {
    name = "transit-gateway-id"
    values = [ aws_ec2_transit_gateway_peering_attachment.main.peer_transit_gateway_id ]
  }
}

resource "aws_ec2_transit_gateway_peering_attachment_accepter" "london_tgpa_accepter" {
  provider = aws.london
  transit_gateway_attachment_id = data.aws_ec2_transit_gateway_peering_attachment.london_tga.id
}
*/