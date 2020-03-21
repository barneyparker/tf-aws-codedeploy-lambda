data "archive_file" "dummy_bundle" {
  type        = "zip"
  source_file = "${path.module}/function.txt"
  output_path = "${path.module}/files/${var.lambda_name}.zip"
}

resource "aws_lambda_function" "lambda" {
  filename      = "${path.module}/files/${var.lambda_name}.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.lambda.arn
  handler       = var.handler
  memory_size   = var.memory_size
  timeout       = var.timeout
  description   = var.description

  publish = true

  source_code_hash = data.archive_file.dummy_bundle.output_base64sha256

  runtime = var.runtime

  environment {
    variables = var.env_vars
  }

  lifecycle {
    ignore_changes = [
      source_code_hash,
      memory_size,
      timeout,
      version,
      qualified_arn,
      last_modified
    ]
  }
}
