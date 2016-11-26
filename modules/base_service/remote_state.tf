data "terraform_remote_state" "cluster_state" {
  backend = "s3"

  config {
    region = "${var.region}"
    bucket = "${var.remote_state_bucket}"
    key    = "${var.environment}-cluster-tf"
  }
}
