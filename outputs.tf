output "ecs_exec_role_policy_id" {
  description = "The ECS service role policy ID, in the form of role_name:role_policy_name"
  value       = module.alb_service_task.ecs_exec_role_policy_id
}

output "ecs_exec_role_policy_name" {
  description = "ECS service role name"
  value       = module.alb_service_task.ecs_exec_role_policy_name
}

output "service_name" {
  description = "ECS Service name"
  value       = module.alb_service_task.service_name
}

output "service_role_arn" {
  description = "ECS Service role ARN"
  value       = module.alb_service_task.service_role_arn
}

output "task_exec_role_name" {
  description = "ECS Task role name"
  value       = module.alb_service_task.task_exec_role_name
}

output "task_exec_role_arn" {
  description = "ECS Task exec role ARN"
  value       = module.alb_service_task.task_exec_role_arn
}

output "task_role_name" {
  description = "ECS Task role name"
  value       = module.alb_service_task.task_role_name
}

output "task_role_arn" {
  description = "ECS Task role ARN"
  value       = module.alb_service_task.task_role_arn
}

output "task_role_id" {
  description = "ECS Task role id"
  value       = module.alb_service_task.task_role_id
}

output "service_security_group_id" {
  description = "Security Group ID of the ECS task"
  value       = module.alb_service_task.service_security_group_id
}

output "task_definition_family" {
  description = "ECS task definition family"
  value       = module.alb_service_task.task_definition_family
}

output "task_definition_revision" {
  description = "ECS task definition revision"
  value       = module.alb_service_task.task_definition_revision
}

output "scale_down_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = module.autoscaling.scale_down_policy_arn
}

output "scale_up_policy_arn" {
  description = "Autoscaling scale up policy ARN"
  value       = module.autoscaling.scale_up_policy_arn
}
