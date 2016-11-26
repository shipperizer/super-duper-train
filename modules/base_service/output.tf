output "task_arns" {
  value = ["${aws_ecs_task_definition.web_td.arn}"]
}

output "cluster" {
    value = "${data.terraform_remote_state.cluster_state.cluster_name}"
}

output "public_dns" {
    value = "${aws_route53_record.web_public_r53.dns_name}"
}
