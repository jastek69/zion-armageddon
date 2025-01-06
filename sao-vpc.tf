resource "aws_vpc" "SAO_VPC" {
  provider = aws.saopaulo  
  cidr_block       = "10.242.0.0/16"
  

  tags = {
    Name = "SAO_VPC"
  }
}

resource "aws_subnet" "SAO_SUBNET" {
  provider = aws.saopaulo
  
  vpc_id     = aws_vpc.SAO_VPC.id
  cidr_block = "10.242.0.0/24"
  availability_zone = "sa-east-1a"
  tags = {
    Name = "SAO_SUBNET"
  }
}

resource "aws_internet_gateway" "SAO_IGW" {
  provider = aws.saopaulo
  
  vpc_id     = aws_vpc.SAO_VPC.id

  tags = {
    Name = "SAO_IGW"
  }
}




# Sao Paulo Route Table
resource "aws_route_table" "SAO_route_table" {        # Route Table ID: aws_route_table.SAO_route_table.id
  provider = aws.saopaulo
  vpc_id = aws_vpc.SAO_VPC.id

  route {
    cidr_block = "10.240.1.0/24" # Route to TOKYO_VPC
    transit_gateway_id = aws_ec2_transit_gateway.sao-tgw.id
    }

  tags = {
    Name = "SAO_ROUTE"
  }
}



/*
# Create a default route table for shared database VPC
resource "aws_default_route_table" "SAO_ROUTE" {
  provider = aws.saopaulo

  default_route_table_id = aws_vpc.SAO_VPC.default_route_table_id

  tags = {
    Name = "SAO_ROUTE"
  }
}

# Create a default route for shared database VPC
resource "aws_route" "SAO_route" {
  provider = aws.saopaulo
  
  route_table_id         = aws_default_route_table.SAO_ROUTE.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.SAO_IGW.id # Replace with actual internet gateway ID

  depends_on = [aws_vpc.SAO_VPC]  # Ensure VPC is created before route
}

*/


# Route to backend services VPC via Transit Gateway Attachment
resource "aws_route" "SAO_to_london" {
  provider = aws.saopaulo
  
  route_table_id         = aws_route_table.SAO_route_table.id
  destination_cidr_block = "10.241.0.0/16"  # Replace with actual london VPC CIDR block
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.sao_attachment.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.sao_attachment]
}

resource "aws_route" "SAO_to_tokyo" {
  provider = aws.saopaulo
  
  route_table_id         = aws_route_table.SAO_route_table.id
  destination_cidr_block = "10.240.0.0/16"  # Replace with actual web_app VPC CIDR block
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.sao_attachment.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.sao_attachment]
}
