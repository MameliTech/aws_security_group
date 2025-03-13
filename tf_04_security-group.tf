#==================================================================
# security-group.tf
#==================================================================

resource "aws_security_group" "this" {
  name        = local.sg_name
  description = "Security Group used by ${local.source_resource}"
  vpc_id      = data.aws_vpc.this.id

  dynamic "ingress" {
    for_each = var.ingress
    content {
      description     = ingress.value.description
      from_port       = ingress.value.from_port
      to_port         = ingress.value.to_port
      protocol        = ingress.value.protocol
      cidr_blocks     = ingress.value.cidr_blocks
      security_groups = ingress.value.security_groups
    }
  }

  egress {
    description = "Outbound traffic rule"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { "Name" : local.sg_name }
}
