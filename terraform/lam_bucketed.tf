resource "aws_lambda_function" "bucketed" {
  function_name = "${var.function_name}-bucket"
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.runtime
  timeout       = 100

  s3_bucket = aws_s3_object.code.bucket
  s3_key    = aws_s3_object.code.key

  handler = "lambda.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.logger.name
  }

  lifecycle {
    replace_triggered_by = [aws_s3_object.code]
  }
}
