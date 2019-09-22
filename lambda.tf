data "archive_file" "dummy_bundle" {
  type        = "zip"
  source_file = "${path.module}/function.txt"
  output_path = "${path.module}/files/${var.lambda_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/files/${var.lambda_name}.zip"
  function_name = "${var.lambda_name}"
  role          = "${aws_iam_role.lambda.arn}"
  handler       = "${var.handler}"
  memory_size   = "${var.memory_size}"
  timeout       = "${var.timeout}"
  description   = "${var.description}"

  publish = true

  source_code_hash = "${data.archive_file.dummy_bundle.output_base64sha256}"

  runtime = "${var.runtime}"

  environment {
    variables = "${var.env_vars}"
  }

  lifecycle {
    ignore_changes = [
      "source_code_hash",
      "version",
      "qualified_arn",
      "last_modified"
    ]
  }
}

resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}-Role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

data "aws_iam_policy_document" "lambda" {
  statement {
    actions = [
      "logs:*"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }
}

resource "aws_iam_role_policy" "lambda" {
  name = "Cloudwatch-Logging"
  role = "${aws_iam_role.lambda.id}"
  policy = "${data.aws_iam_policy_document.lambda.json}"
}

resource "aws_lambda_alias" "aliases" {
  count = "${length(var.aliases)}"

  name             = "${var.aliases[count.index]}"
  function_name    = "${var.lambda_name}"
  function_version = "1"

  lifecycle {
    ignore_changes = [
      "function_version"
    ]
  }
}

output "alias_arns" {
  value = "aws_lambda_alias.aliases.*.arn"
}

output "alias_invoke_arns" {
  value = "aws_lambda_alias.aliases.*.invoke_arn"
}
