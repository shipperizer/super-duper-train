output "db_host" {
  value = "${aws_db_instance.postgres_main.address}"
}

output "vpc_id" {
  value = "${var.vpc_id}"
}

output "cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "sg_cluster" {
  value = "${aws_security_group.ecs_instance.id}"
}

output "ecs_iam_role_id" {
  value = "${aws_iam_role.ecs_instance.id}"
}

output "elb_iam_role_id" {
  value = "${aws_iam_role.elb_iam_role.id}"
}

output "postgres_subnet" {
  value = "${aws_db_subnet_group.postgres_subnet.id}"
}
