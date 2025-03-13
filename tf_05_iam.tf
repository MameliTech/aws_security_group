#==================================================================
# security-group - iam.tf
#==================================================================

#------------------------------------------------------------------
# IAM Policy - Security Group - Read-Only
#------------------------------------------------------------------
resource "aws_iam_policy" "sg_ro" {
  name = local.iam_sg_ro

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "ReadOnly",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSecurityGroupRules",
          "ec2:DescribeTags",
          "ec2:DescribeNetworkInterfaces"
        ],
        "Resource" : aws_security_group.this.arn,
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "true"
          }
        }
      }
    ]
  })

  tags = { "Name" : local.iam_sg_ro }
}
