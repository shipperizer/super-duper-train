resource "aws_iam_role" "elb_iam_role" {
  name = "elb_iam_role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ecs.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "elb_iam_role_policy" {
  name   = "elb_policy-${var.environment}"
  role   = "${aws_iam_role.elb_iam_role.id}"
  policy = "${file("${path.module}/policies/elb_iam_role_policy.json")}"
}

resource "aws_iam_instance_profile" "ecs_instance" {
  name  = "ecs_instance-${var.environment}"
  roles = ["${aws_iam_role.ecs_instance.name}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "ecs_instance" {
  name = "ecs_instance_iam_role-${var.environment}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ec2.amazonaws.com", "ecs.amazonaws.com"]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy" "ecs_service_policy" {
  name   = "ecs_service-policy-${var.environment}"
  role   = "${aws_iam_role.ecs_instance.id}"
  policy = "${file("${path.module}/policies/ecs_service_policy.json")}"
}
