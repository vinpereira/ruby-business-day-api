# Internet VPC

resource "aws_vpc" "business-days-vpc" {
  cidr_block = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = "true"
  enable_dns_hostnames = "true"
  enable_classiclink = "false"

  tags {
    Name = "business-days-vpc"
  }
}

# Public subnets
resource "aws_subnet" "business-days-subnet-public-1" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"

  tags {
    Name = "business-days-subnet-public-1"
  }
}

resource "aws_subnet" "business-days-subnet-public-2" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.2.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1b"

  tags {
    Name = "business-days-subnet-public-2"
  }
}

resource "aws_subnet" "business-days-subnet-public-3" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.3.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1c"

  tags {
    Name = "business-days-subnet-public-3"
  }
}

# Private subnets
resource "aws_subnet" "business-days-subnet-private-1" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.4.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1a"

  tags {
    Name = "business-days-subnet-private-1"
  }
}

resource "aws_subnet" "business-days-subnet-private-2" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.5.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1b"

  tags {
    Name = "business-days-subnet-private-2"
  }
}

resource "aws_subnet" "business-days-subnet-private-3" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"
  cidr_block = "10.0.6.0/24"
  map_public_ip_on_launch = "false"
  availability_zone = "us-east-1c"

  tags {
    Name = "business-days-subnet-private-3"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "business-days-gateway" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"

  tags {
    Name = "business-days-gateway"
  }
}

# Route tables
resource "aws_route_table" "business-days-route-table-public" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.business-days-gateway.id}"
  }

  tags {
    Name = "business-days-route-table-public"
  }
}

# Route associations public
resource "aws_route_table_association" "business-days-association-public-1-a" {
  subnet_id = "${aws_subnet.business-days-subnet-public-1.id}"
  route_table_id = "${aws_route_table.business-days-route-table-public.id}"
}

resource "aws_route_table_association" "business-days-association-public-2-a" {
  subnet_id = "${aws_subnet.business-days-subnet-public-2.id}"
  route_table_id = "${aws_route_table.business-days-route-table-public.id}"
}

resource "aws_route_table_association" "business-days-association-public-3-a" {
  subnet_id = "${aws_subnet.business-days-subnet-public-3.id}"
  route_table_id = "${aws_route_table.business-days-route-table-public.id}"
}
