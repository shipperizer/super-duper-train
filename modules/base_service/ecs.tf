resource "aws_ecs_service" "ecs_web_service" {
  name            = "${var.service_name}-${var.environment}"
  task_definition = "${aws_ecs_task_definition.web_td.arn}"
  desired_count   = "1"
  cluster         = "${data.terraform_remote_state.cluster_state.cluster_name}"
  iam_role        = "${data.terraform_remote_state.cluster_state.ecs_iam_role_id}"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.alb.arn}"
    container_name   = "${var.service_name}-${var.environment}"
    container_port   = "${var.container_port}"
  }
}

resource "aws_ecs_task_definition" "web_td" {
  family                = "${var.service_name}-${var.environment}"
  container_definitions = "${data.template_file.web_td_template.rendered}"
}

data "template_file" "web_td_template" {
  template = "${file("${path.module}/td/web_td.json")}"

  vars {
    service_name           = "${var.service_name}-${var.environment}"
    docker_image           = "${var.image_name_and_tag}"
    container_port         = "${var.container_port}"
    container_cpu_limit    = 64
    container_memory_limit = 64
  }
}
