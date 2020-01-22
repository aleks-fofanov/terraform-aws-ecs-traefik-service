#############################################################
# Locals
#############################################################

locals {
  default_docker_labels = {
    "traefik.enable"        = var.dashboard_enabled
    "traefik.port"          = var.api_port
    "traefik.frontend.rule" = "Host: ${var.dashboard_host}"
    "traefik.backend"       = "traefik"
  }

  basic_auth_docker_labels = {
    enabled = {
      "traefik.frontend.auth.basic" = "${var.dashboard_basic_auth_user}:${var.dashboard_basic_auth_password}"
    }
    disabled = {}
  }

  traefik_docker_labels = merge(
    local.default_docker_labels,
    lookup(local.basic_auth_docker_labels, var.dashboard_basic_auth_enabled ? "enabled" : "disabled", {})
  )

  logs_region = var.logs_region == "" ? var.ecs_cluster_region : var.logs_region
}

#############################################################
# Labels
#############################################################

module "default_label" {
  source     = "git::https://github.com/cloudposse/terraform-null-label.git?ref=tags/0.16.0"
  attributes = var.attributes
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags
}

#############################################################
# Task Defenitions
#############################################################

module "traefik_container_definition" {
  source                       = "git::https://github.com/cloudposse/terraform-aws-ecs-container-definition?ref=tags/0.23.0"
  container_name               = var.container_name
  container_image              = var.task_image
  container_memory             = var.task_memory
  container_memory_reservation = var.task_memory_reservation
  container_cpu                = var.task_cpu

  command = [
    "--loglevel=${var.log_level}",
    "--traefikLog.format=${var.log_format}",
    "--api",
    "--api.dashboard=${var.dashboard_enabled}",
    "--api.entryPoint=traefik",
    "--ping",
    "--ping.entrypoint=http",
    "--ecs.clusters=${var.ecs_cluster_name}",
    "--ecs.exposedbydefault=false",
    "--ecs.region=${var.ecs_cluster_region}",
    "--defaultentrypoints=http",
    "--entryPoints=Name:http Address::${var.http_port}",
    "--entryPoints=Name:traefik Address::${var.api_port}",
  ]

  port_mappings = [
    {
      containerPort = var.http_port
      hostPort      = var.http_port
      protocol      = "tcp"
    },
    {
      containerPort = var.api_port
      hostPort      = var.api_port
      protocol      = "tcp"
    },
  ]

  mount_points = var.mount_points

  log_configuration = {
    logDriver = "awslogs"
    options = {
      "awslogs-region"        = local.logs_region
      "awslogs-group"         = aws_cloudwatch_log_group.default.name
      "awslogs-stream-prefix" = var.container_name
    }
    secretOptions = []
  }

  docker_labels = local.traefik_docker_labels
}

#############################################################
# Service
#############################################################

module "alb_service_task" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecs-alb-service-task.git?ref=tags/0.21.0"
  attributes = var.attributes
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags

  launch_type                       = var.launch_type
  task_cpu                          = var.task_cpu
  task_memory                       = var.task_memory
  health_check_grace_period_seconds = var.health_check_grace_period_seconds

  container_definition_json = module.traefik_container_definition.json
  desired_count             = var.desired_count
  assign_public_ip          = var.assign_public_ip

  network_mode       = "awsvpc"
  ecs_cluster_arn    = var.ecs_cluster_arn
  alb_security_group = var.alb_security_group_id

  ecs_load_balancers = [
    {
      container_name   = var.container_name
      container_port   = var.http_port
      elb_name         = ""
      target_group_arn = var.alb_target_group_arn
    }
  ]

  vpc_id             = var.vpc_id
  subnet_ids         = var.subnet_ids
  security_group_ids = compact(concat(var.security_group_ids, [aws_security_group.default.id]))

  volumes = var.volumes

  deployment_controller_type         = var.deployment_controller_type
  deployment_maximum_percent         = var.deployment_maximum_percent
  deployment_minimum_healthy_percent = var.deployment_minimum_healthy_percent

  ignore_changes_task_definition = var.ignore_changes_task_definition
}

#############################################################
# IAM Roles
#############################################################

# Per https://docs.traefik.io/v1.7/configuration/backends/ecs/#policy

data "aws_iam_policy_document" "traefik" {
  statement {
    sid    = "TraefikECSReadAccess"
    effect = "Allow"

    actions = [
      "ecs:ListClusters",
      "ecs:DescribeClusters",
      "ecs:ListTasks",
      "ecs:DescribeTasks",
      "ecs:DescribeContainerInstances",
      "ecs:DescribeTaskDefinition",
      "ec2:DescribeInstances",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_policy" "traefik_ecs_task_role_additions" {
  name   = module.default_label.id
  policy = data.aws_iam_policy_document.traefik.json
}

resource "aws_iam_role_policy_attachment" "traefik_ecs_task_role_additions" {
  role       = module.alb_service_task.task_role_name
  policy_arn = aws_iam_policy.traefik_ecs_task_role_additions.arn
}

#############################################################
# Cloudwatch
#############################################################

resource "aws_cloudwatch_log_group" "default" {
  provider = aws.logs

  name              = "ECS/${module.default_label.id}"
  retention_in_days = var.logs_retention

  tags = module.default_label.tags
}

#############################################################
# Security Groups
#############################################################

resource "aws_security_group" "default" {
  vpc_id = var.vpc_id
  name   = module.default_label.id

  tags = module.default_label.tags
}

resource "aws_security_group_rule" "ingress_http" {
  type              = "ingress"
  security_group_id = aws_security_group.default.id

  from_port                = var.http_port
  to_port                  = var.http_port
  protocol                 = "tcp"
  source_security_group_id = var.alb_security_group_id
}

#############################################################
# Autoscaing
#############################################################

module "autoscaling" {
  enabled    = var.autoscaling_enabled
  source     = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-autoscaling.git?ref=tags/0.2.0"
  attributes = var.attributes
  delimiter  = var.delimiter
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  tags       = var.tags

  service_name          = module.alb_service_task.service_name
  cluster_name          = var.ecs_cluster_name
  min_capacity          = var.autoscaling_min_capacity
  max_capacity          = var.autoscaling_max_capacity
  scale_down_adjustment = var.autoscaling_scale_down_adjustment
  scale_down_cooldown   = var.autoscaling_scale_down_cooldown
  scale_up_adjustment   = var.autoscaling_scale_up_adjustment
  scale_up_cooldown     = var.autoscaling_scale_up_cooldown
}

locals {
  cpu_utilization_high_alarm_actions    = var.autoscaling_enabled && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_up_policy_arn : ""
  cpu_utilization_low_alarm_actions     = var.autoscaling_enabled && var.autoscaling_dimension == "cpu" ? module.autoscaling.scale_down_policy_arn : ""
  memory_utilization_high_alarm_actions = var.autoscaling_enabled && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_up_policy_arn : ""
  memory_utilization_low_alarm_actions  = var.autoscaling_enabled && var.autoscaling_dimension == "memory" ? module.autoscaling.scale_down_policy_arn : ""
}

module "ecs_alarms" {
  source     = "git::https://github.com/cloudposse/terraform-aws-ecs-cloudwatch-sns-alarms.git?ref=tags/0.5.0"
  name       = var.name
  namespace  = var.namespace
  stage      = var.stage
  attributes = var.attributes
  tags       = var.tags

  enabled      = var.ecs_alarms_enabled
  cluster_name = var.ecs_cluster_name
  service_name = module.alb_service_task.service_name

  cpu_utilization_high_threshold          = var.ecs_alarms_cpu_utilization_high_threshold
  cpu_utilization_high_evaluation_periods = var.ecs_alarms_cpu_utilization_high_evaluation_periods
  cpu_utilization_high_period             = var.ecs_alarms_cpu_utilization_high_period
  cpu_utilization_high_alarm_actions = compact(
    concat(
      var.ecs_alarms_cpu_utilization_high_alarm_actions,
      [local.cpu_utilization_high_alarm_actions],
    ),
  )
  cpu_utilization_high_ok_actions = var.ecs_alarms_cpu_utilization_high_ok_actions

  cpu_utilization_low_threshold          = var.ecs_alarms_cpu_utilization_low_threshold
  cpu_utilization_low_evaluation_periods = var.ecs_alarms_cpu_utilization_low_evaluation_periods
  cpu_utilization_low_period             = var.ecs_alarms_cpu_utilization_low_period
  cpu_utilization_low_alarm_actions = compact(
    concat(
      var.ecs_alarms_cpu_utilization_low_alarm_actions,
      [local.cpu_utilization_low_alarm_actions],
    ),
  )
  cpu_utilization_low_ok_actions = var.ecs_alarms_cpu_utilization_low_ok_actions

  memory_utilization_high_threshold          = var.ecs_alarms_memory_utilization_high_threshold
  memory_utilization_high_evaluation_periods = var.ecs_alarms_memory_utilization_high_evaluation_periods
  memory_utilization_high_period             = var.ecs_alarms_memory_utilization_high_period
  memory_utilization_high_alarm_actions = compact(
    concat(
      var.ecs_alarms_memory_utilization_high_alarm_actions,
      [local.memory_utilization_high_alarm_actions],
    ),
  )
  memory_utilization_high_ok_actions = var.ecs_alarms_memory_utilization_high_ok_actions

  memory_utilization_low_threshold          = var.ecs_alarms_memory_utilization_low_threshold
  memory_utilization_low_evaluation_periods = var.ecs_alarms_memory_utilization_low_evaluation_periods
  memory_utilization_low_period             = var.ecs_alarms_memory_utilization_low_period
  memory_utilization_low_alarm_actions = compact(
    concat(
      var.ecs_alarms_memory_utilization_low_alarm_actions,
      [local.memory_utilization_low_alarm_actions],
    ),
  )
  memory_utilization_low_ok_actions = var.ecs_alarms_memory_utilization_low_ok_actions
}
