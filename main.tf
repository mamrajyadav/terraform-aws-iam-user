# Managed By : CloudDrove
# Description : Terraform module to create IAM user resource on AWS.
# Copyright @ CloudDrove. All Right Reserved.

#Module      : label
#Description : This terraform module is designed to generate consistent label names and tags
#              for resources. You can use terraform-labels to implement a strict naming
#              convention.


module "labels" {
  source  = "clouddrove/labels/aws"
  version = "0.15.0"

  name        = var.name
  environment = var.environment
  repository  = var.repository
  managedby   = var.managedby
  attributes  = var.attributes
  label_order = var.label_order
}

# Module      : IAM user
# Description : Terraform module to create IAm user resource on AWS.
resource "aws_iam_user" "default" {
  count = var.enabled ? 1 : 0

  name                 = module.labels.id
  force_destroy        = var.force_destroy
  path                 = var.path
  permissions_boundary = var.permissions_boundary

  tags = merge(
    module.labels.tags,
    {
      "Name" = format("%s%s%s", module.labels.id, var.delimiter, "defualt")
    }
  )

}

resource "aws_iam_access_key" "default" {
  count = var.enabled ? 1 : 0

  user    = aws_iam_user.default.*.name[0]
  pgp_key = var.pgp_key
  status  = var.status
}

resource "aws_iam_user_policy" "default" {
  count = var.enabled && var.policy_enabled && var.policy_arn == "" ? 1 : 0

  name   = format("%s%spolicy", module.labels.id, var.delimiter)
  user   = aws_iam_user.default.*.name[0]
  policy = var.policy
}

resource "aws_iam_user_policy_attachment" "default" {
  count = var.enabled && var.policy_enabled && var.policy_arn != "" ? 1 : 0

  user       = aws_iam_user.default.*.name[0]
  policy_arn = var.policy_arn
}

resource "aws_iam_group" "group1" {
  name = "group1"
}

resource "aws_iam_user_group_membership" "example1" {
  count      = var.enabled && var.membership_enabled ? 1 : 0
  user = join("", aws_iam_user.default.*.name)

  groups = [
    aws_iam_group.group1.name
  ]
}


resource "aws_iam_user_ssh_key" "user" {
  count = var.enabled && var.ssh_key_enabled ? 1 : 0
  username   = join("", aws_iam_user.default.*.name)
  encoding   = var.encoding
  public_key = var.public_key
}