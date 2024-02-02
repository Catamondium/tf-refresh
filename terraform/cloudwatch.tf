# common logger
resource "aws_cloudwatch_log_group" "logger" {
  name = "/experimental/${var.project_name}"
}

data "aws_iam_policy_document" "cw_document" {

  statement {

    # we now control log creation, lambda just needs these rights
    actions = ["logs:CreateLogStream", "logs:PutLogEvents"]

    resources = [
      "${aws_cloudwatch_log_group.logger.arn}:*"
    ]
  }
}

data "aws_iam_policy_document" "trust" {

  statement {

    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "log_policy" {
  policy = data.aws_iam_policy_document.cw_document.json
}

resource "aws_iam_role" "lambda_role" {
  name_prefix         = "${var.project_name}-role"
  assume_role_policy  = data.aws_iam_policy_document.trust.json
  managed_policy_arns = [aws_iam_policy.log_policy.arn]
}
