provider "aws" {
  region = "eu-west-2"
  default_tags {
    tags = {
      project_name = var.project_name
      terraform    = true
    }
  }
}

resource "aws_resourcegroups_group" "tracker" {
  name = "${var.project_name}-group"
  resource_query {
    query = jsonencode({
      ResourceTypeFilters = ["AWS::Lambda::Function"]
      TagFilters = [{
        Key    = "project_name"
        Values = [var.project_name]
        }
      ]
    })
  }
}
