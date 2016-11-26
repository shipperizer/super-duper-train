resource "aws_db_instance" "postgres_main" {
  identifier             = "${var.environment}-postgres-main"
  allocated_storage      = "${var.rds_allocated_storage}"
  engine                 = "postgres"
  engine_version         = "9.6.0"
  instance_class         = "${var.rds_instance_class}"
  username               = "${var.rds_database_user}"
  password               = "${var.rds_database_password}"
  vpc_security_group_ids = ["${aws_security_group.postgres_main-sg.id}"]
  db_subnet_group_name   = "${aws_db_subnet_group.postgres_subnet.id}"
  multi_az               = "${var.is_rds_multi_az}"
  publicly_accessible    = "${var.is_rds_publicly_accessible}"
}

resource "aws_security_group" "postgres_main-sg" {
  description = "Security group for services-${var.environment} RDS instance"
  vpc_id      = "${var.vpc_id}"

  # Outbound Everything
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = "5432"
    to_port         = "5432"
    protocol        = "tcp"
    security_groups = ["${aws_security_group.ecs_instance.id}"]
  }
}

resource "aws_db_subnet_group" "postgres_subnet" {
  name       = "postgres_subnet-${var.environment}"
  subnet_ids = "${var.direct_subnets}"

  tags {
    Name = "${var.environment} postgres subnet group"
  }
}
