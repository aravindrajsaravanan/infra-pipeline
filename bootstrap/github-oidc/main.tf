# One-time setup, run locally by an admin (not by the pipeline):
#   cd bootstrap/github-oidc && terraform init && terraform apply
# Then set the output role_arn as GitHub repo variable AWS_ROLE_ARN.

terraform {
  required_version = ">= 1.10"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.100"
    }
  }
}

provider "aws" {
  region = var.region
}

variable "region" {
  description = "AWS region the pipeline deploys to"
  type        = string
  default     = "ap-south-1"
}

variable "github_repo" {
  description = "GitHub repo allowed to assume the role (owner/name)"
  type        = string
  default     = "aravindrajsaravanan/infra-pipeline"
}

variable "state_bucket" {
  description = "S3 bucket holding Terraform state"
  type        = string
  default     = "storage-718460151470-ap-south-1-an"
}

variable "create_oidc_provider" {
  description = "Set false if the GitHub OIDC provider already exists in the account"
  type        = bool
  default     = true
}

data "aws_caller_identity" "current" {}

resource "aws_iam_openid_connect_provider" "github" {
  count          = var.create_oidc_provider ? 1 : 0
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
}

locals {
  oidc_arn = var.create_oidc_provider ? aws_iam_openid_connect_provider.github[0].arn : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
}

data "aws_iam_policy_document" "trust" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [local.oidc_arn]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values = [
        "repo:${var.github_repo}:ref:refs/heads/dev",
        "repo:${var.github_repo}:ref:refs/heads/main",
        "repo:${var.github_repo}:environment:development",
      ]
    }
  }
}

resource "aws_iam_role" "github_terraform" {
  name                 = "github-actions-terraform"
  assume_role_policy   = data.aws_iam_policy_document.trust.json
  max_session_duration = 3600
}

data "aws_iam_policy_document" "permissions" {
  # Terraform state in S3 (native lockfile => needs Put/Delete on .tflock)
  statement {
    sid       = "StateList"
    actions   = ["s3:ListBucket"]
    resources = ["arn:aws:s3:::${var.state_bucket}"]
  }
  statement {
    sid       = "StateObjects"
    actions   = ["s3:GetObject", "s3:PutObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.state_bucket}/env/*"]
  }
  # VPC / subnet / EC2 management, limited to the deploy region
  statement {
    sid       = "Ec2InRegion"
    actions   = ["ec2:*"]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.region]
    }
  }
}

resource "aws_iam_role_policy" "github_terraform" {
  name   = "terraform-deploy"
  role   = aws_iam_role.github_terraform.id
  policy = data.aws_iam_policy_document.permissions.json
}

output "role_arn" {
  description = "Set this as GitHub repo variable AWS_ROLE_ARN"
  value       = aws_iam_role.github_terraform.arn
}
