// 4 subnets here, vpc passed in

// 1a-1b + 2a-2b

// cidr block x.x.x.x/25

resource "aws_subnet" "base_eu-w1a_direct" {
  vpc_id            = "${aws_vpc.base_vpc1.id}"
  cidr_block        = "${var.direct_1a_cidr}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "base_eu-w1a_direct"
  }
}

resource "aws_subnet" "base_eu-w1b_direct" {
  vpc_id            = "${aws_vpc.base_vpc1.id}"
  cidr_block        = "${var.direct_1b_cidr}"
  availability_zone = "eu-west-1b"

  tags {
    Name = "base_eu-w1b_direct"
  }
}

resource "aws_subnet" "base_eu-w1a_nat" {
  vpc_id            = "${aws_vpc.base_vpc1.id}"
  cidr_block        = "${var.nat_1a_cidr}"
  availability_zone = "eu-west-1a"

  tags {
    Name = "base_eu-w1a_nat"
  }
}

resource "aws_subnet" "base_eu-w1b_nat" {
  vpc_id            = "${aws_vpc.base_vpc1.id}"
  cidr_block        = "${var.nat_1b_cidr}"
  availability_zone = "eu-west-1b"

  tags {
    Name = "base_eu-w1b_nat"
  }
}

resource "aws_internet_gateway" "base_igw" {
  vpc_id = "${aws_vpc.base_vpc1.id}"

  tags {
    Name = "base_igw"
  }
}

resource "aws_nat_gateway" "gw1-1a" {
  allocation_id = "${aws_eip.natgw1.id}"
  subnet_id     = "${aws_subnet.base_eu-w1a_direct.id}"
}

resource "aws_nat_gateway" "gw2-1b" {
  allocation_id = "${aws_eip.natgw2.id}"
  subnet_id     = "${aws_subnet.base_eu-w1b_direct.id}"
}

resource "aws_eip" "natgw1" {
  vpc = true
}

resource "aws_eip" "natgw2" {
  vpc = true
}

resource "aws_route_table" "aws_rt1_nat" {
  vpc_id = "${aws_vpc.base_vpc1.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw1-1a.id}"
  }

  tags {
    Name = "aws_eu-1a_rt1_nat_tf"
  }
}

resource "aws_route_table" "aws_rt2_nat" {
  vpc_id = "${aws_vpc.base_vpc1.id}"

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.gw2-1b.id}"
  }

  tags {
    Name = "aws_eu-1b_rt2_nat_tf"
  }
}

resource "aws_route_table" "aws_rt3_direct" {
  vpc_id = "${aws_vpc.base_vpc1.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.base_igw.id}"
  }

  tags {
    Name = "aws_eu_rt3_direct_tf"
  }
}

resource "aws_route_table_association" "base_aws_rt1_nat_route_association" {
  subnet_id      = "${aws_subnet.base_eu-w1a_nat.id}"
  route_table_id = "${aws_route_table.aws_rt1_nat.id}"
}

resource "aws_route_table_association" "base_aws_rt2_nat_route_association" {
  subnet_id      = "${aws_subnet.base_eu-w1b_nat.id}"
  route_table_id = "${aws_route_table.aws_rt2_nat.id}"
}

resource "aws_route_table_association" "base_aws_rt3a_direct_route_association" {
  subnet_id      = "${aws_subnet.base_eu-w1a_direct.id}"
  route_table_id = "${aws_route_table.aws_rt3_direct.id}"
}

resource "aws_route_table_association" "base_aws_rt3b_direct_route_association" {
  subnet_id      = "${aws_subnet.base_eu-w1b_direct.id}"
  route_table_id = "${aws_route_table.aws_rt3_direct.id}"
}
