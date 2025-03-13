#==================================================================
# security-group - outputs.tf
#==================================================================

#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
output "arn" {
  description = "O ARN do Security Group."
  value       = aws_security_group.this.arn
}

output "id" {
  description = "O ID do Security Group."
  value       = aws_security_group.this.id
}


#------------------------------------------------------------------
# IAM Policy
#------------------------------------------------------------------
output "policy_map" {
  description = "Mapa com ARNs de politicas de acesso ('acao' : 'arn')."
  value = {
    "security-group_ro" : aws_iam_policy.sg_ro.arn
  }
}
