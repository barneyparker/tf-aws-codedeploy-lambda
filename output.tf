output "deployment_config_id" {
  value = "${var.deployment_config == "" ? aws_codedeploy_deployment_config.cd_config[0].id : var.deployment_config}"
}

output "deployment_role_arn" {
  value = "${var.deployment_role_arn == "" ? aws_iam_role.cd_role[0].arn : var.deployment_role_arn}"
}
