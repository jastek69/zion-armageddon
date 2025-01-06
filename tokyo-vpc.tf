resource "aws_vpc" "TOKYO_VPC" {              # VPC ID: aws_vpc.TOKYO_VPC.id  
  cidr_block       = "10.240.0.0/16"
  

  tags = {
    Name = "TOKYO_VPC"
  }
}

resource "aws_subnet" "TOKYO_SUBNET" {
  vpc_id     = aws_vpc.TOKYO_VPC.id 
  cidr_block = "10.240.0.0/24"
  availability_zone = "ap-northeast-1a"
  tags = {
    Name = "TOKYO_SUBNET"
  }
}

resource "aws_internet_gateway" "TOKYO_IGW" {     # Internet Gateway ID: aws_internet_gateway.TOKYO_IGW.id
  vpc_id     = aws_vpc.TOKYO_VPC.id

  tags = {
    Name = "TOKYO_IGW"
  }
}

# TOKYO Route Table
resource "aws_route_table" "TOKYO_route_table" {        # Route Table ID: aws_route_table.TOKYO_ROUTE.id
  vpc_id = aws_vpc.TOKYO_VPC.id

  route {
    cidr_block = "10.241.1.0/24" # Route to LONDON_VPC
    transit_gateway_id = aws_ec2_transit_gateway.tokyo-tgw.id
    }

  tags = {
    Name = "TOKYO_ROUTE"
  }
}


/*
resource "aws_default_route_table" "TOKYO_route_table" {    # Route Table ID: aws_route_table.TOKYO_route_table.id
  default_route_table_id = aws_vpc.TOKYO_VPC.default_route_table_id

  tags = {
    Name = "TOKYO_ROUTE"
  }
}


resource "aws_route" "TOKYO_route" {
  route_table_id         = aws_route_table.TOKYO_route_table_table.id
  
  
  #destination_cidr_block = "0.0.0.0/0"    # Route all traffic to the Internet Gateway
  #gateway_id             = aws_internet_gateway.TOKYO_IGW.id

  depends_on = [aws_vpc.TOKYO_VPC]  # Ensure VPC is created before route
}
*/




/* TRANSIT GATEWAY ATTACHMENT */
# Route to LONDON_VPC via Transit Gateway Attachment
resource "aws_route" "TOKYO_to_london" {
  route_table_id         = aws_route_table.TOKYO_route_table.id
  destination_cidr_block = "10.241.0.0/16"  # Replace with actual VPC2 CIDR block
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment]
}


# Route to SAO_VPC via Transit Gateway Attachment
resource "aws_route" "TOKYO_to_sao" {
  route_table_id         = aws_route_table.TOKYO_route_table.id
  destination_cidr_block = "10.243.0.0/16"  # Replace with actual VPC3 CIDR block
  transit_gateway_id     = aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment.transit_gateway_id

  depends_on = [aws_ec2_transit_gateway_vpc_attachment.tokyo_attachment]
}
