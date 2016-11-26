variable "region" {
  default = "eu-west-1"
}

variable "container_port" {
  default = 9000
}

variable "service_name" {
  default = "phoenix-service"
}

variable "r53_zone_id" {
  type = "map"

  default = {
    staging    = "staging"
    production = "production"
  }
}

variable "direct_subnets" {
  type = "map"

  default = {
    staging    = []
    production = []
  }
}

variable "remote_state_bucket" {
  default = "terraform-cluster-state"
}

variable "sg_id" {
  type = "map"
  description = "SG that allows external access"

  default = {
    staging    = "sg-staging"
    production = "sg-production"
  }
}

variable "image_name_and_tag" {}

variable "environment" {}
