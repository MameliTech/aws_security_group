#==================================================================
# security-group - variables.tf
#==================================================================

#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
variable "foundation_squad" {
  description = "Nome da squad definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_application" {
  description = "Nome da aplicacao definida na VPC que sera utilizada."
  type        = string
}

variable "foundation_environment" {
  description = "Acronimo do ambiente definido na VPC que sera utilizada."
  type        = string
}

variable "foundation_role" {
  description = "Nome da funcao definida na VPC que sera utilizada."
  type        = string
}


#------------------------------------------------------------------
# Resource Nomenclature
#------------------------------------------------------------------
variable "rn_squad" {
  description = "Nome da squad. Limitado a 8 caracteres."
  type        = string
}

variable "rn_application" {
  description = "Nome da aplicacao. Limitado a 8 caracteres."
  type        = string
}

variable "rn_environment" {
  description = "Acronimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres."
  type        = string
}

variable "rn_role" {
  description = "Funcao do recurso. Limitado a 8 caracteres."
  type        = string
}


#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
variable "resource_type_abbreviation" {
  description = "Abreviacao do tipo de recurso que utiliza o Security Group."
  type        = string
  default     = ""
  nullable    = false
}

variable "ingress" {
  description = "Define as regras entrada do Security Group. Descricao conforme a liberacao, porta, protocolo e range de IP."
  type = list(object({
    description     = string
    from_port       = number
    to_port         = number
    protocol        = string
    cidr_blocks     = optional(list(string))
    security_groups = optional(list(string))
  }))
}
