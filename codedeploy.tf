resource "aws_iam_role" "cd_role" {
  count = "${var.deployment_config == "" ? 1 : 0}"

  name = "${var.application_name}-${var.application_group}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "cd_policy" {
  count = "${var.deployment_config == "" ? 1 : 0}"

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
  role = "${aws_iam_role.cd_role[0].name}"
}

resource "aws_codedeploy_deployment_config" "cd_config" {
  count = "${var.deployment_config == "" ? 1 : 0}"

  deployment_config_name = "${var.application_name}-${var.application_group}-config"
  compute_platform = "Lambda"

  traffic_routing_config {
    type = "TimeBasedLinear"

    time_based_linear {
      interval = "${var.deployment_interval}"
      percentage = "${var.deployment_percentage}"
    }
  }
}

resource "aws_codedeploy_deployment_group" "cd_group" {
  app_name = "${var.application_name}"
  deployment_group_name = "${var.application_group}"
  service_role_arn = "${var.deployment_role_arn == "" ? aws_iam_role.cd_role[0].arn : var.deployment_role_arn}"
  deployment_config_name = "${var.deployment_config == "" ? aws_codedeploy_deployment_config.cd_config[0].id : var.deployment_config}"

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type = "BLUE_GREEN"
  }

  auto_rollback_configuration {
    enabled = true
    events = [
      "DEPLOYMENT_FAILURE",
      "DEPLOYMENT_STOP_ON_ALARM"
    ]
  }
}