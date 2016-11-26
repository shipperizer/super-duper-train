resource "aws_vpc" "base_vpc1" {
  cidr_block           = "${var.vpc_cidr}"
  instance_tenancy     = "shared"
  enable_dns_support   = "true"
  enable_dns_hostnames = "true"
  instance_tenancy     = "default"

  tags {
    "Name"        = "vpc_base"
    "Description" = "Main VPC"
  }
}
