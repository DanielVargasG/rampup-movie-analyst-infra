resource "aws_cloudwatch_dashboard" "this" {
  dashboard_name = "${var.env_name}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric", x = 0, y = 0, width = 12, height = 6,
        properties = {
          title   = "CPU — backend / front"
          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.backend_instance_id, { label = "backend" }],
            ["AWS/EC2", "CPUUtilization", "InstanceId", var.front_instance_id, { label = "front" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
        }
      },
      {
        type = "metric", x = 12, y = 0, width = 12, height = 6,
        properties = {
          title   = "Memoria usada (%) — backend / front"
          metrics = [
            ["rampup/${var.env_name}", "mem_used_percent", "InstanceId", var.backend_instance_id, { label = "backend" }],
            ["rampup/${var.env_name}", "mem_used_percent", "InstanceId", var.front_instance_id, { label = "front" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
        }
      },
      {
        type = "metric", x = 0, y = 6, width = 12, height = 6,
        properties = {
          title   = "Disco usado (%) — backend / front"
          metrics = [
            ["rampup/${var.env_name}", "disk_used_percent", "InstanceId", var.backend_instance_id, { label = "backend" }],
            ["rampup/${var.env_name}", "disk_used_percent", "InstanceId", var.front_instance_id, { label = "front" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
        }
      },
      {
        type = "metric", x = 12, y = 6, width = 12, height = 6,
        properties = {
          title   = "ALB — targets sanos / no sanos"
          metrics = [
            ["AWS/ApplicationELB", "HealthyHostCount", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix],
            ["AWS/ApplicationELB", "UnHealthyHostCount", "LoadBalancer", var.alb_arn_suffix, "TargetGroup", var.target_group_arn_suffix]
          ]
          period = 60
          stat   = "Maximum"
          region = "us-east-2"
        }
      },
      {
        type = "metric", x = 0, y = 12, width = 12, height = 6,
        properties = {
          title   = "RDS — CPU y espacio libre"
          metrics = [
            ["AWS/RDS", "CPUUtilization", "DBInstanceIdentifier", var.db_instance_id, { label = "CPU %" }],
            ["AWS/RDS", "FreeStorageSpace", "DBInstanceIdentifier", var.db_instance_id, { label = "Free storage (bytes)", yAxis = "right" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-2"
        }
      }
    ]
  })
}