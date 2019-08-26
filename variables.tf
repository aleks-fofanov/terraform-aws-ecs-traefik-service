variable "namespace" {
  type        = "string"
  description = "Namespace (e.g. `cp` or `cloudposse`)"
  default     = "cp"
}

variable "stage" {
  type        = "string"
  description = "Stage (e.g. `prod`, `dev`, `staging`)"
  default     = "prod"
}

variable "name" {
  type        = "string"
  default     = "traefik"
  description = "Solution name, e.g. 'app' or 'jenkins'"
}

variable "delimiter" {
  type        = "string"
  default     = "-"
  description = "Delimiter to be used between `namespace`, `name`, `stage` and `attributes`"
}

variable "attributes" {
  type        = "list"
  default     = []
  description = "Additional attributes, e.g. `1`"
}

variable "tags" {
  type        = "map"
  default     = {}
  description = "Additional tags (e.g. `map(`BusinessUnit`,`XYZ`)"
}

variable "vpc_id" {
  type        = "string"
  description = "Id of VPC in which Traefik service should be deployed"
}

variable "alb_security_group_id" {
  type        = "string"
  description = "ALB security group id. Traefik container will accept traefik from port 80"
}

variable "alb_target_group_arn" {
  type        = "string"
  description = "ALB security group id. Traefik container will accept traefik from port 80"
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = "list"
}

variable "ecs_cluster_name" {
  type        = "string"
  description = "ECS cluster name"
}

variable "ecs_cluster_arn" {
  type        = "string"
  description = "ECS cluster ARN"
}

variable "ecs_cluster_region" {
  type        = "string"
  default     = "us-east-1"
  description = "ECS cluster region"
}

variable "security_group_ids" {
  description = "Additional security group IDs to allow in Service `network_configuration`"
  type        = "list"
  default     = []
}

variable "launch_type" {
  type        = "string"
  description = "The launch type on which to run your service. Valid values are `EC2` and `FARGATE`"
  default     = "FARGATE"
}

variable "assign_public_ip" {
  type        = "string"
  default     = "false"
  description = "Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false."
}

variable "container_name" {
  type        = "string"
  default     = "traefik"
  description = "The name of the container in task definition to associate with the load balancer"
}

variable "task_image" {
  type        = "string"
  default     = "library/traefik:1.7"
  description = "Traefik image"
}

variable "task_cpu" {
  type        = "string"
  description = "The vCPU setting to control cpu limits of traefik container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "256"
}

variable "task_memory" {
  type        = "string"
  description = "The amount of RAM to allow traefik container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html)"
  default     = "512"
}

variable "task_memory_reservation" {
  type        = "string"
  description = "The amount of RAM (Soft Limit) to allow traefik container to use in MB. This value must be less than container_memory if set"
  default     = "128"
}

variable "log_level" {
  type        = "string"
  default     = "INFO"
  description = "Traefk log level. See https://docs.traefik.io/configuration/logs/"
}

variable "log_format" {
  type        = "string"
  default     = "common"
  description = "Traefk log format. See https://docs.traefik.io/configuration/logs/"
}

variable "logs_retention" {
  type        = "string"
  default     = "30"
  description = "Defines retention period in days for Traefik logs in Cloudwatch"
}

variable "logs_region" {
  type        = "string"
  default     = ""
  description = "AWS region for storing Cloudwatch logs from traefik container. Defaults to the same as ECS Cluster region."
}

variable "http_port" {
  type        = "string"
  default     = "80"
  description = "Port at which Traefik will accept traffic from ALB"
}

variable "api_port" {
  type        = "string"
  default     = "8080"
  description = "Port at which Traefik will expose the API and Dashboard"
}

variable "dashboard_enabled" {
  type        = "string"
  default     = "false"
  description = "Defines whether traefik dashboard is enabled"
}

variable "dashboard_host" {
  type        = "string"
  default     = "dashboard.example.com"
  description = "Traefik dashboard host at which API should be exposed"
}

variable "dashboard_basic_auth_enabled" {
  type        = "string"
  default     = "true"
  description = "Defines whther basic auth is enabled for Traefik dashboard or not"
}

variable "dashboard_basic_auth_user" {
  type        = "string"
  default     = "admin"
  description = "Basic auth username for Traefik dashboard"
}

variable "dashboard_basic_auth_password" {
  type        = "string"
  default     = ""
  description = "Basic auth password for Traefik dashboard. If left empty, a random one will be generated."
}

variable "desired_count" {
  description = "The number of instances of the task definition to place and keep running"
  default     = 1
}

variable "deployment_controller_type" {
  description = "Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`."
  default     = "ECS"
}

variable "deployment_maximum_percent" {
  description = "The upper limit of the number of tasks (as a percentage of `desired_count`) that can be running in a service during a deployment"
  default     = 200
}

variable "deployment_minimum_healthy_percent" {
  description = "The lower limit (as a percentage of `desired_count`) of the number of tasks that must remain running and healthy in a service during a deployment"
  default     = 100
}

variable "health_check_grace_period_seconds" {
  type        = "string"
  description = "Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers"
  default     = 10
}

variable "mount_points" {
  type        = "list"
  description = "Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume`"
  default     = []

  #default     = [
  #  {
  #    containerPath  = "/tmp"
  #    sourceVolume = "test-volume"
  #  }
  #]
}

variable "volumes" {
  type        = "list"
  description = "Task volume definitions as list of maps"
  default     = []
}

variable "ignore_changes_task_definition" {
  type        = "string"
  description = "Whether to ignore changes in container definition and task definition in the ECS service"
  default     = "true"
}

variable "autoscaling_enabled" {
  type        = "string"
  description = "A boolean to enable/disable Autoscaling policy for ECS Service"
  default     = "false"
}

variable "autoscaling_dimension" {
  type        = "string"
  description = "Dimension to autoscale on (valid options: cpu, memory)"
  default     = "memory"
}

variable "autoscaling_min_capacity" {
  type        = "string"
  description = "Minimum number of running instances of a Service"
  default     = "1"
}

variable "autoscaling_max_capacity" {
  type        = "string"
  description = "Maximum number of running instances of a Service"
  default     = "2"
}

variable "autoscaling_scale_up_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale up event"
  default     = "1"
}

variable "autoscaling_scale_up_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale up events"
  default     = "60"
}

variable "autoscaling_scale_down_adjustment" {
  type        = "string"
  description = "Scaling adjustment to make during scale down event"
  default     = "-1"
}

variable "autoscaling_scale_down_cooldown" {
  type        = "string"
  description = "Period (in seconds) to wait between scale down events"
  default     = "300"
}

variable "ecs_alarms_enabled" {
  type        = "string"
  description = "A boolean to enable/disable CloudWatch Alarms for ECS Service metrics"
  default     = "false"
}

variable "ecs_alarms_cpu_utilization_high_threshold" {
  type        = "string"
  description = "The maximum percentage of CPU utilization average"
  default     = "80"
}

variable "ecs_alarms_cpu_utilization_high_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_cpu_utilization_high_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_cpu_utilization_high_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_high_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_threshold" {
  type        = "string"
  description = "The minimum percentage of CPU utilization average"
  default     = "20"
}

variable "ecs_alarms_cpu_utilization_low_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_cpu_utilization_low_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_cpu_utilization_low_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_cpu_utilization_low_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_threshold" {
  type        = "string"
  description = "The maximum percentage of Memory utilization average"
  default     = "80"
}

variable "ecs_alarms_memory_utilization_high_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_memory_utilization_high_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_memory_utilization_high_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_high_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_threshold" {
  type        = "string"
  description = "The minimum percentage of Memory utilization average"
  default     = "20"
}

variable "ecs_alarms_memory_utilization_low_evaluation_periods" {
  type        = "string"
  description = "Number of periods to evaluate for the alarm"
  default     = "1"
}

variable "ecs_alarms_memory_utilization_low_period" {
  type        = "string"
  description = "Duration in seconds to evaluate for the alarm"
  default     = "300"
}

variable "ecs_alarms_memory_utilization_low_alarm_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action"
  default     = []
}

variable "ecs_alarms_memory_utilization_low_ok_actions" {
  type        = "list"
  description = "A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action"
  default     = []
}
