data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
data "archive_file" "lambda_archive" {
  type        = "zip"
  source_file = "${path.module}/../lambda.py"
  output_path = "${path.module}/../function.zip"

  depends_on = [null_resource.sauce]
}

resource "aws_s3_bucket" "code_bucket" {
  bucket_prefix = "${var.project_name}-bucket"
}

resource "aws_s3_object" "code" {
  bucket = aws_s3_bucket.code_bucket.bucket
  key    = "${var.function_name}/function.zip"
  source = data.archive_file.lambda_archive.output_path

  lifecycle {
    replace_triggered_by = [null_resource.sauce]
  }
}

resource "null_resource" "sauce" {
  triggers = {
    main = sha256(file("${path.module}/../lambda.py"))
  }
}
