#==================================================================
# security-group - resource-names.tf
#==================================================================

locals {
  sg_name         = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-${var.resource_type_abbreviation}-sg"
  source_resource = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-${var.resource_type_abbreviation}"
  iam_sg_ro       = "${var.rn_squad}-${var.rn_application}-${var.rn_environment}-${var.rn_role}-AccessToSG_${var.resource_type_abbreviation}_ro"
}
