## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| alb_security_group_id | ALB security group id. Traefik container will accept traefik from port 80 | string | - | yes |
| alb_target_group_arn | ALB security group id. Traefik container will accept traefik from port 80 | string | - | yes |
| api_port | Port at which Traefik will expose the API and Dashboard | string | `8080` | no |
| assign_public_ip | Assign a public IP address to the ENI (Fargate launch type only). Valid values are true or false. Default false. | string | `false` | no |
| attributes | Additional attributes, e.g. `1` | list | `<list>` | no |
| autoscaling_dimension | Dimension to autoscale on (valid options: cpu, memory) | string | `memory` | no |
| autoscaling_enabled | A boolean to enable/disable Autoscaling policy for ECS Service | string | `false` | no |
| autoscaling_max_capacity | Maximum number of running instances of a Service | string | `2` | no |
| autoscaling_min_capacity | Minimum number of running instances of a Service | string | `1` | no |
| autoscaling_scale_down_adjustment | Scaling adjustment to make during scale down event | string | `-1` | no |
| autoscaling_scale_down_cooldown | Period (in seconds) to wait between scale down events | string | `300` | no |
| autoscaling_scale_up_adjustment | Scaling adjustment to make during scale up event | string | `1` | no |
| autoscaling_scale_up_cooldown | Period (in seconds) to wait between scale up events | string | `60` | no |
| container_name | The name of the container in task definition to associate with the load balancer | string | `traefik` | no |
| dashboard_basic_auth_enabled | Defines whther basic auth is enabled for Traefik dashboard or not | string | `true` | no |
| dashboard_basic_auth_password | Basic auth password for Traefik dashboard. If left empty, a random one will be generated. | string | `` | no |
| dashboard_basic_auth_user | Basic auth username for Traefik dashboard | string | `admin` | no |
| dashboard_enabled | Defines whether traefik dashboard is enabled | string | `false` | no |
| dashboard_host | Traefik dashboard host at which API should be exposed | string | `dashboard.example.com` | no |
| delimiter | Delimiter to be used between `namespace`, `name`, `stage` and `attributes` | string | `-` | no |
| deployment_controller_type | Type of deployment controller. Valid values: `CODE_DEPLOY`, `ECS`. | string | `ECS` | no |
| deployment_maximum_percent | The upper limit of the number of tasks (as a percentage of `desired_count`) that can be running in a service during a deployment | string | `200` | no |
| deployment_minimum_healthy_percent | The lower limit (as a percentage of `desired_count`) of the number of tasks that must remain running and healthy in a service during a deployment | string | `100` | no |
| desired_count | The number of instances of the task definition to place and keep running | string | `1` | no |
| ecs_alarms_cpu_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization High OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_high_threshold | The maximum percentage of CPU utilization average | string | `80` | no |
| ecs_alarms_cpu_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_cpu_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on CPU Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_cpu_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_cpu_utilization_low_threshold | The minimum percentage of CPU utilization average | string | `20` | no |
| ecs_alarms_enabled | A boolean to enable/disable CloudWatch Alarms for ECS Service metrics | string | `false` | no |
| ecs_alarms_memory_utilization_high_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_high_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization High OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_high_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_high_threshold | The maximum percentage of Memory utilization average | string | `80` | no |
| ecs_alarms_memory_utilization_low_alarm_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low Alarm action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_evaluation_periods | Number of periods to evaluate for the alarm | string | `1` | no |
| ecs_alarms_memory_utilization_low_ok_actions | A list of ARNs (i.e. SNS Topic ARN) to notify on Memory Utilization Low OK action | list | `<list>` | no |
| ecs_alarms_memory_utilization_low_period | Duration in seconds to evaluate for the alarm | string | `300` | no |
| ecs_alarms_memory_utilization_low_threshold | The minimum percentage of Memory utilization average | string | `20` | no |
| ecs_cluster_arn | ECS cluster ARN | string | - | yes |
| ecs_cluster_name | ECS cluster name | string | - | yes |
| ecs_cluster_region | ECS cluster region | string | `us-east-1` | no |
| health_check_grace_period_seconds | Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 7200. Only valid for services configured to use load balancers | string | `10` | no |
| http_port | Port at which Traefik will accept traffic from ALB | string | `80` | no |
| ignore_changes_task_definition | Whether to ignore changes in container definition and task definition in the ECS service | string | `true` | no |
| launch_type | The launch type on which to run your service. Valid values are `EC2` and `FARGATE` | string | `FARGATE` | no |
| log_format | Traefk log format. See https://docs.traefik.io/configuration/logs/ | string | `common` | no |
| log_level | Traefk log level. See https://docs.traefik.io/configuration/logs/ | string | `INFO` | no |
| logs_region | AWS region for storing Cloudwatch logs from traefik container. Defaults to the same as ECS Cluster region. | string | `` | no |
| logs_retention | Defines retention period in days for Traefik logs in Cloudwatch | string | `30` | no |
| mount_points | Container mount points. This is a list of maps, where each map should contain a `containerPath` and `sourceVolume` | list | `<list>` | no |
| name | Solution name, e.g. 'app' or 'jenkins' | string | `traefik` | no |
| namespace | Namespace (e.g. `cp` or `cloudposse`) | string | `cp` | no |
| security_group_ids | Additional security group IDs to allow in Service `network_configuration` | list | `<list>` | no |
| stage | Stage (e.g. `prod`, `dev`, `staging`) | string | `prod` | no |
| subnet_ids | Subnet IDs | list | - | yes |
| tags | Additional tags (e.g. `map(`BusinessUnit`,`XYZ`) | map | `<map>` | no |
| task_cpu | The vCPU setting to control cpu limits of traefik container. (If FARGATE launch type is used below, this must be a supported vCPU size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `256` | no |
| task_image | Traefik image | string | `library/traefik:1.7` | no |
| task_memory | The amount of RAM to allow traefik container to use in MB. (If FARGATE launch type is used below, this must be a supported Memory size from the table here: https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-cpu-memory-error.html) | string | `512` | no |
| task_memory_reservation | The amount of RAM (Soft Limit) to allow traefik container to use in MB. This value must be less than container_memory if set | string | `128` | no |
| volumes | Task volume definitions as list of maps | list | `<list>` | no |
| vpc_id | Id of VPC in which Traefik service should be deployed | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| ecs_exec_role_policy_id | The ECS service role policy ID, in the form of role_name:role_policy_name |
| ecs_exec_role_policy_name | ECS service role name |
| scale_down_policy_arn | Autoscaling scale up policy ARN |
| scale_up_policy_arn | Autoscaling scale up policy ARN |
| service_name | ECS Service name |
| service_role_arn | ECS Service role ARN |
| service_security_group_id | Security Group ID of the ECS task |
| task_definition_family | ECS task definition family |
| task_definition_revision | ECS task definition revision |
| task_exec_role_arn | ECS Task exec role ARN |
| task_exec_role_name | ECS Task role name |
| task_role_arn | ECS Task role ARN |
| task_role_id | ECS Task role id |
| task_role_name | ECS Task role name |

