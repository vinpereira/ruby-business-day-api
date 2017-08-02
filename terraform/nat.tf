# NAT gateway
resource "aws_eip" "business-days-nat" {
  vpc = true
}

resource "aws_nat_gateway" "business-days-nat-gw" {
  allocation_id = "${aws_eip.business-days-nat.id}"
  subnet_id     = "${aws_subnet.business-days-subnet-public-1.id}"
  depends_on    = ["aws_internet_gateway.business-days-gateway"]
}

# VPC setup for NAT
resource "aws_route_table" "business-days-route-table-private" {
  vpc_id = "${aws_vpc.business-days-vpc.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.business-days-nat-gw.id}"
  }

  tags {
    Name = "business-days-route-table-private"
  }
}

# Route associations private
resource "aws_route_table_association" "business-days-association-private-1-a" {
  subnet_id      = "${aws_subnet.business-days-subnet-private-1.id}"
  route_table_id = "${aws_route_table.business-days-route-table-private.id}"
}

resource "aws_route_table_association" "business-days-association-private-2-a" {
  subnet_id      = "${aws_subnet.business-days-subnet-private-2.id}"
  route_table_id = "${aws_route_table.business-days-route-table-private.id}"
}

resource "aws_route_table_association" "business-days-association-private-3-a" {
  subnet_id      = "${aws_subnet.business-days-subnet-private-3.id}"
  route_table_id = "${aws_route_table.business-days-route-table-private.id}"
}
