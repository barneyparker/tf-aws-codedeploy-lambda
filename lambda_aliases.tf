resource "aws_lambda_alias" "aliases" {
  count = length(var.aliases)

  name             = var.aliases[count.index]
  #function_name    = var.lambda_name
  function_name     = aws_lambda_function.lambda.arn
  function_version = aws_lambda_function.lambda.version

  lifecycle {
    ignore_changes = [
      "function_version"
    ]
  }
}