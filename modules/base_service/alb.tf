resource "aws_alb" "alb" {
  name = "${var.service_name}-alb-${var.environment}"

  subnets         = "${var.direct_subnets[var.environment]}"
  security_groups = ["${aws_security_group.alb_sg.id}", "${lookup(var.sg_id, var.environment)}"]

  internal = false

  idle_timeout = 400
}

resource "aws_alb_listener" "web" {
  load_balancer_arn = "${aws_alb.alb.arn}"
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = "${aws_alb_target_group.web.arn}"
    type             = "forward"
  }
}

resource "aws_alb_target_group" "web" {
  name     = "${var.service_name}-${var.environment}-alb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${data.terraform_remote_state.cluster_state.vpc_id}"

  health_check {
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 3
    protocol            = "HTTP"
    interval            = 30
    matcher             = "200,302"
  }
}

resource "aws_security_group" "alb_sg" {
  name        = "${var.service_name}-elb-${var.environment}"
  description = "Security group for ${var.service_name}-alb-${var.environment}"
  vpc_id      = "${data.terraform_remote_state.cluster_state.vpc_id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// all docker range allowed as port allocated dynamically
resource "aws_security_group_rule" "alb_inbound_rule_on_ecs" {
  security_group_id        = "${data.terraform_remote_state.cluster_state.sg_cluster}"
  type                     = "ingress"
  from_port                = 32768
  to_port                  = 61000
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.alb_sg.id}"
}

resource "aws_route53_record" "web_public_r53" {
  zone_id = "${lookup(var.r53_zone_id, var.environment)}"
  name    = "${var.service_name}-${var.environment}"
  type    = "CNAME"
  ttl     = "60"
  records = ["${aws_alb.alb.dns_name}"]
}
