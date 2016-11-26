output "route_table_1_nat" {
  value = "${aws_route_table.aws_rt1_nat.id}"
}

output "route_table_2_nat" {
  value = "${aws_route_table.aws_rt2_nat.id}"
}

output "route_table_3_direct" {
  value = "${aws_route_table.aws_rt3_direct.id}"
}

output "vpc_id" {
  value = "${aws_vpc.base_vpc1.id}"
}

output "subnet_1a_direct" {
  value = "${aws_subnet.base_eu-w1a_direct.id}"
}

output "subnet_1b_direct" {
  value = "${aws_subnet.base_eu-w1b_direct.id}"
}

output "subnet_1a_nat" {
  value = "${aws_subnet.base_eu-w1a_nat.id}"
}

output "subnet_1b_nat" {
  value = "${aws_subnet.base_eu-w1b_nat.id}"
}

output "jumpbox_ip" {
  value = "${aws_eip.jumpbox_public_eip.public_ip}"
}

output "jumpbox_id" {
  value = "${aws_instance.jumpbox.id}"
}
