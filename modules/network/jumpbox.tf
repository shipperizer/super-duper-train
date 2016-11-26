resource "aws_instance" "jumpbox" {
  ami           = "${var.ami_id}"
  instance_type = "t2.nano"
  key_name      = "${var.key_pair_name}"

  tags {
    Name = "Jump Box"
  }

  subnet_id                   = "${aws_subnet.base_eu-w1a_direct.id}"
  security_groups             = ["${aws_security_group.jumpbox_instance.id}"]
  associate_public_ip_address = true
}

resource "aws_security_group" "jumpbox_instance" {
  name        = "jumpbox_sg"
  description = "Security group for the jumpbox"
  vpc_id      = "${aws_vpc.base_vpc1.id}"

  # Outbound Everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "nat_sg" {
  name        = "nat_sg"
  description = "Security group for ec2 instances in the nat"
  vpc_id      = "${aws_vpc.base_vpc1.id}"

  # Outbound Everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_subnet.base_eu-w1a_nat.cidr_block}"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${aws_subnet.base_eu-w1b_nat.cidr_block}"]
  }
}

resource "aws_eip" "jumpbox_public_eip" {
  vpc = true
}

resource "aws_eip_association" "jumpbox_eip_assoc" {
  instance_id   = "${aws_instance.jumpbox.id}"
  allocation_id = "${aws_eip.jumpbox_public_eip.id}"
}
