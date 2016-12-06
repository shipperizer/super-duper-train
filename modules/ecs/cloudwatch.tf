resource "aws_cloudwatch_metric_alarm" "memory__gte" {
  alarm_name                = "terraform-memory-ecs-gte"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "This metric monitor ecs cluster memory utilization"
  insufficient_data_actions = []

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs_cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.memory_ecs_cluster_scale_up.arn}"]
}

resource "aws_cloudwatch_metric_alarm" "memory_sentry_celery_lte" {
  alarm_name                = "terraform-memory-ecs-lte"
  comparison_operator       = "LessThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "MemoryUtilization"
  namespace                 = "AWS/ECS"
  period                    = "300"
  statistic                 = "Average"
  threshold                 = "75"
  alarm_description         = "This metric monitor ecs cluster memory utilization"
  insufficient_data_actions = []

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs_cluster.name}"
  }

  alarm_actions = ["${aws_autoscaling_policy.memory_ecs_cluster_scale_down.arn}"]
}
