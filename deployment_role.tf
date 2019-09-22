resource "aws_iam_role" "cd_role" {
  count = var.deployment_role_arn == "" ? 1 : 0

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
  count = var.deployment_role_arn == "" ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRoleForLambda"
  role = aws_iam_role.cd_role[0].name
}
