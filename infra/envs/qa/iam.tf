# ===================== Backend: lee solo sus parámetros de conexión a BD =====================
data "aws_iam_policy_document" "backend_ssm_read" {
  statement {
    actions = ["ssm:GetParameter", "ssm:GetParameters"]
    resources = [
      "arn:aws:ssm:us-east-2:*:parameter/rampup/qa/db/host",
      "arn:aws:ssm:us-east-2:*:parameter/rampup/qa/db/port",
      "arn:aws:ssm:us-east-2:*:parameter/rampup/qa/db/name",
      "arn:aws:ssm:us-east-2:*:parameter/rampup/qa/db/app_username",
      "arn:aws:ssm:us-east-2:*:parameter/rampup/qa/db/app_password",
    ]
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:us-east-2:*:alias/aws/ssm"]
  }
}

resource "aws_iam_role" "backend" {
  name = "qa-backend-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "backend_ssm" {
  name   = "ssm-read-db-params"
  role   = aws_iam_role.backend.id
  policy = data.aws_iam_policy_document.backend_ssm_read.json
}

resource "aws_iam_instance_profile" "backend" {
  name = "qa-backend-profile"
  role = aws_iam_role.backend.name
}

# ===================== Bastion: lee todo /rampup/qa/* + describe instances =====================
data "aws_iam_policy_document" "bastion_ssm_read" {
  statement {
    actions   = ["ssm:GetParameter", "ssm:GetParameters", "ssm:GetParametersByPath"]
    resources = ["arn:aws:ssm:us-east-2:*:parameter/rampup/qa/*"]
  }
  statement {
    actions   = ["kms:Decrypt"]
    resources = ["arn:aws:kms:us-east-2:*:alias/aws/ssm"]
  }
  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeSubnets",
      "ec2:DescribeVpcs",
      "ec2:DescribeTags",
    ]
    resources = ["*"] # estas acciones de EC2 no admiten scoping por ARN
}
}

resource "aws_iam_role" "bastion" {
  name = "qa-bastion-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "bastion_ssm" {
  name   = "ssm-read-all-rampup"
  role   = aws_iam_role.bastion.id
  policy = data.aws_iam_policy_document.bastion_ssm_read.json
}

resource "aws_iam_instance_profile" "bastion" {
  name = "qa-bastion-profile"
  role = aws_iam_role.bastion.name
}