resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.cluster_name}-${var.environment}"

  lifecycle {
    create_before_destroy = true
  }
}

data "template_file" "userdata" {
  template = "${file("${path.module}/userdata.sh")}"

  vars {
    aws_ecs_cluster_name = "${var.cluster_name}-${var.environment}"
  }
}


resource "aws_launch_configuration" "ecs_instance" {
  name_prefix          = "${var.cluster_name}-ecs-cluster-instance-${var.environment}"
  instance_type        = "${var.instance_type}"
  key_name             = "${var.key_pair_name}"
  iam_instance_profile = "${aws_iam_instance_profile.ecs_instance.name}"
  security_groups      = ["${aws_security_group.ecs_instance.id}"]
  image_id             = "${data.aws_ami.ecs_ami.id}"

  user_data = "${data.template_file.userdata.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "ecs_cluster_instances" {
  name                 = "ecs-cluster-instances-${var.environment}"
  min_size             = "${var.minimum_cluster_size}"
  max_size             = "${var.maximum_cluster_size}"
  desired_capacity     = "${var.desired_cluster_size}"
  launch_configuration = "${aws_launch_configuration.ecs_instance.name}"
  vpc_zone_identifier  = "${var.nat_subnets}"

  tag {
    key                 = "Name"
    value               = "ecs-cluster-${var.cluster_name}-instances-${var.environment}"
    propagate_at_launch = true
  }
}

resource "aws_security_group" "ecs_instance" {
  name        = "ecs_cluster_${var.cluster_name}_${var.environment}"
  description = "Security group for the EC2 instances in the ${var.cluster_name} ${var.environment} cluster"
  vpc_id      = "${var.vpc_id}"

  # Outbound Everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${var.jumpbox_sg}"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${var.nat_sg}"]
  }

  # aws_launch_configuration.ecs_instance sets create_before_destroy to true, which means every resource it depends on,
  # including this one, must also set the create_before_destroy flag to true, or you'll get a cyclic dependency error.
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_ami" "ecs_ami" {
  most_recent = true
  executable_users = ["self"]
  filter {
    name = "name"
    values = ["base_ecs_*"]
  }
  owners = ["self"]
}
