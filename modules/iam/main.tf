resource "aws_iam_role" "ec2_role" {

  name = "${local.name_prefix}-ec2-role"

  assume_role_policy = file(
    "${path.module}/policies/ec2-assume-role.json"
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-ec2-role"
    }
  )
}

resource "aws_iam_policy" "ec2_policy" {

  name = "${local.name_prefix}-ec2-policy"

  policy = file(
    "${path.module}/policies/ec2-policy.json"
  )

  tags = local.common_tags
}


resource "aws_iam_role_policy_attachment" "ec2_attach" {

  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}


resource "aws_iam_role_policy_attachment" "ssm_managed" {

  role = aws_iam_role.ec2_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}


resource "aws_iam_instance_profile" "ec2_profile" {

  name = "${local.name_prefix}-ec2-profile"

  role = aws_iam_role.ec2_role.name
}


resource "aws_iam_role" "fis_role" {

  name = "${local.name_prefix}-fis-role"

  assume_role_policy = file(
    "${path.module}/policies/fis-assume-role.json"
  )

  tags = merge(
    local.common_tags,
    {
      Name = "${local.name_prefix}-fis-role"
    }
  )
}


resource "aws_iam_policy" "fis_policy" {

  name = "${local.name_prefix}-fis-policy"

  policy = file(
    "${path.module}/policies/fis-policy.json"
  )

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "fis_attach" {

  role       = aws_iam_role.fis_role.name
  policy_arn = aws_iam_policy.fis_policy.arn
}