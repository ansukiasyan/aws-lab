resource "aws_vpc" "test" {
    cidr_block = "10.0.0.0/16"

    tags = {
        Name = "tf_testVPC"
    }      
}

resource "aws_subnet" "public" {
    vpc_id = aws_vpc.test.id
    availability_zone = "us-east-2a"
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    tags = {
        Name = "10.0.1.0 - us-east-2a"
    }
  
}

resource "aws_subnet" "private" {
    vpc_id = aws_vpc.test.id
    availability_zone = "us-east-2b"
    cidr_block = "10.0.2.0/24"

    tags = {
        Name = "10.0.2.0 - us-east-2b"
    }
  
}

resource "aws_internet_gateway" "test" {
    vpc_id = aws_vpc.test.id
    tags = {
        Name = "tf_testIGW"
    }  
}

resource "aws_route_table" "public" {
    vpc_id = aws_vpc.test.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.test.id
    }
    tags = {
        Name = "public_route_table"
    }  
}

resource "aws_route_table_association" "public" {
    subnet_id = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

#Route the internet traffic from the private subnet through the NAT instance 
resource "aws_route" "NAT" {
    route_table_id = aws_vpc.test.main_route_table_id
    destination_cidr_block = "0.0.0.0/0"   
    instance_id = aws_instance.NAT.id   
}
