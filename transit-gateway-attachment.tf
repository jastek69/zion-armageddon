# Transit Gateway Attachment
# Creating attachments for each VPC to its respective Transit Gateway
# Creating Peering Connection for inter-region peering connections between Transit Gateways
################################################################################################

# TRANSIT GATEWAY ATTACHMENTS



# Attach TOKYO_VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "tokyo_attachment" {
  # ID of the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.tokyo-tgw.id
  subnet_ids = [
    aws_subnet.TOKYO_SUBNET.id  # Reference the created subnet ID
  ]
  # VPC ID to be attached
  vpc_id = aws_vpc.TOKYO_VPC.id

  # Optional tags for identification
  tags = {
    Name = "Tokyo VPC Attachment"
  }
}

# Attach LONDON VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "london_attachment" {
  provider = aws.london

  # ID of the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.london-tgw.id
  subnet_ids = [
    aws_subnet.LONDON_SUBNET.id  # Reference the created subnet ID
  ]
  # VPC ID to be attached
  vpc_id = aws_vpc.LONDON_VPC.id

  # Optional tags for identification
  tags = {
    Name = "London VPC Attachment"
  }
}

# Attach Sao Paulo VPC to the Transit Gateway
resource "aws_ec2_transit_gateway_vpc_attachment" "sao_attachment" {
  provider = aws.saopaulo

  # ID of the Transit Gateway
  transit_gateway_id = aws_ec2_transit_gateway.sao-tgw.id
  subnet_ids = [
    aws_subnet.SAO_SUBNET.id  # Reference the created subnet ID
  ]
  # VPC ID to be attached
  vpc_id = aws_vpc.SAO_VPC.id

  # Optional tags for identification
  tags = {
    Name = "Sao Paulo VPC Attachment"
  }
}


# PEERING ATTACHMENTS

# Tokyo VPC to London VPC
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_tokyo_london_peering" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo-tgw.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.london-tgw.id # London Transit Gateway ID to Peer WITH
  peer_region = "eu-west-2"  # London region to Peer WITH
  

  tags = {
    Name = "Tokyo London Peering Attachment"
  }
}


# Tokyo VPC to Sao Paulo VPC
resource "aws_ec2_transit_gateway_peering_attachment" "tgw_tokyo_sao_peering" {
  transit_gateway_id = aws_ec2_transit_gateway.tokyo-tgw.id
  peer_transit_gateway_id = aws_ec2_transit_gateway.sao-tgw.id # Sao Paulo Transit Gateway ID to Peer WITH
  peer_region = "sa-east-1"  # Sao Paulo region to Peer WITH



  tags = {
    Name = "Tokyo Sao Peering Attachment"
  }
}



################################################################################################
/* Transit Gateway Route Tables as Data */

#London Route
/*
data "aws_ec2_transit_gateway_route_table" "tokyo-tgwrt" {
    provider = aws

    filter {
      name   = "tokyo-default-association-route-table"
      values = ["true"]
    }

    filter {
      name   = "tokyo-transit-gateway-id"
      values = [aws_ec2_transit_gateway.tokyo-tgw.id]
    }

    tags = {
      Name = "tokyo tgw tokyo-aas route table"
    }
  }

  resource "aws_ec2_transit_gateway_route" "tokyo-tgwr-ingress" {
    # Internet to VPC Tokyo
    destination_cidr_block = "0.0.0.0/0" # Route all traffic to the Internet Gateway
    transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo-tgwrt.id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment.id
    provider = aws
  }


resource "aws_ec2_transit_gateway_route" "tokyo-tgwr-egress" {
    # Tokyo VPC to London VPC
    destination_cidr_block = "10.241.0.0/24" # Route all traffic to the Internet Gateway
    transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo-tgwrt.id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment.id
    provider = aws
  }


    #London Route   
    data "aws_ec2_transit_gateway_route_table" "london-tgwrt" {
    provider = aws.london

    filter {
      name   = "london-association-route-table"
      values = ["true"]
    }

    filter {
      name   = "london-transit-gateway-id"
      values = [aws_ec2_transit_gateway.london-tgw.id]
    }

    tags = {
      Name = "london main tgw london-aas route table"
    }
  }

  resource "aws_ec2_transit_gateway_route" "london-tgwr" {
    destination_cidr_block = "10.240.0.0/24" # Route to Tokyo VPC
    transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.tokyo-tgwrt.id
    transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment.id
    provider = aws.london
  }


    #Sao Paulo
    data "aws_ec2_transit_gateway_route_table" "sao-tgwrt" {
    provider = aws.saopaulo

    filter {
      name   = "sao-default-association-route-table"
      values = ["true"]
    }

    filter {
      name   = "sao-transit-gateway-id"
      values = [aws_ec2_transit_gateway.sao-tgw.id]
    }

    tags = {
      Name = "sao main tgw sao-aas route table"
    }
  }

    resource "aws_ec2_transit_gateway_route" "sao-tgwr" {
        destination_cidr_block = "10.240.0.0/24" # Route to Tokyo VPC
        transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.sao-tgwrt.id
        transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.sao_attachment.id
        provider = aws.saopaulo
    }

*/
################################################################################################
#  Accepter 
/*
# Accept Tokyo Transit Gateway it in London
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "london_accepter" {
  provider = aws.london

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.london_attachment.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.london_attachment]
 
  tags = {
    Name = "london_accepter"
    Side = "Accepter"
  }
}


# Accept Tokyo Transit in Sao Paulo
resource "aws_ec2_transit_gateway_vpc_attachment_accepter" "sao_accepter" {
  provider = aws.saopaulo

  transit_gateway_attachment_id = aws_ec2_transit_gateway_vpc_attachment.sao_attachment.id
  depends_on = [aws_ec2_transit_gateway_vpc_attachment.sao_attachment]

  tags = {
    Name = "sao_accepter"
    Side = "Accepter"
  }
}
*/
