variable "region" {
  default = "eu-west-1"
}

variable "rds_allocated_storage" {
  default = 10
}

variable "rds_instance_class" {
  default = "db.t2.small"
}

variable "rds_database_user" {
  default = "postgres"
}

variable "rds_database_password" {}

variable "is_rds_multi_az" {
  default = "false"
}

variable "is_rds_publicly_accessible" {
  default = "true"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "minimum_cluster_size" {
  default = "0"
}

variable "maximum_cluster_size" {
  default = "2"
}

variable "desired_cluster_size" {
  default = "1"
}

variable "jumpbox_sg" {}

variable "nat_sg" {}

variable "nat_subnets" {
  type = "list"
}

variable "direct_subnets" {
  type = "list"
}

variable "cluster_name" {}

variable "key_pair_name" {}

# VPC where the ecs cluster lives
variable "vpc_id" {}

variable "environment" {}
