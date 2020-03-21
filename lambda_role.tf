resource "aws_iam_role" "lambda" {
  name = "${var.lambda_name}-role"

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
  role = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda.json
}

resource "aws_iam_role_policy_attachment" "external_policy" {
  count = length(var.policy_arns)
  role = aws_iam_role.lambda.id
  policy_arn = var.policy_arns[count.index]
}
