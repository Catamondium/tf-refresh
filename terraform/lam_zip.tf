resource "aws_lambda_function" "zipped" {
  function_name = "${var.function_name}-zip"
  role          = aws_iam_role.lambda_role.arn
  runtime       = var.runtime
  timeout       = 100

  filename = data.archive_file.lambda_archive.output_path

  handler = "lambda.lambda_handler"

  logging_config {
    log_format = "Text"
    log_group  = aws_cloudwatch_log_group.logger.name
  }
}
