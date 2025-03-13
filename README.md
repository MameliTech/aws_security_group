# AWS Security Group

![Provedor](https://img.shields.io/badge/provider-AWS-orange) ![Engine](https://img.shields.io/badge/engine-Security_Group-blueviolet) ![Versão](https://img.shields.io/badge/version-v.1.0.0-success) ![Coordenação](https://img.shields.io/badge/coord.-Mameli_Tech-informational)<br>

Módulo desenvolvido para o provisionamento de **AWS Security Group**.

Este módulo tem como objetivo criar um Security Group seguindo os padrões da Mameli Tech.

Serão criados os seguintes recursos:
1. **Security Group** com o nome no padrão <span style="font-size: 12px;">`NomeDaEquipe-NomeDaAplicação-Ambiente-FunçãoDoRecurso-sg-AbreviaçãoTipoRecurso`</span>
2. **IAM Policy** com permissão ***Read-Only*** ao Security Group com o nome no padrão <span style="font-size: 12px;">`AccessToSG-NomeDaAplicação-Ambiente-FunçãoDoRecurso-AbreviaçãoTipoRecurso_ro`</span>

## Como utilizar?

### Passo 1

Precisamos configurar o Terraform para armazenar o estado dos recursos criados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_01_backend.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# backend.tf - Script de definicao do Backend
#==================================================================

terraform {
  backend "s3" {
    encrypt = true
  }
}
```

### Passo 2

Precisamos armazenar as definições de variáveis que serão utilizadas pelo Terraform.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_02_variables.tf` com o conteúdo a seguir.<br>
Caso exista, adicione o conteúdo abaixo no arquivo:

```hcl
#==================================================================
# variables.tf - Script de definicao de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
variable "account_region" {
  description = "Define a regiao onde os recursos serao alocados."
  type        = string
}


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
# Resource Nomenclature & Tags
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

variable "default_tags" {
  description = "TAGs padrao que serao adicionadas a todos os recursos."
  type        = map(string)
}


#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
variable "security-group" {
  type = map(object({
    rn_role                    = string
    resource_type_abbreviation = string
    ingress = list(object({
      description = string
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
  }))
}
```

### Passo 3

Precisamos configurar informar o Terraform em qual região os recursos serão implementados.<br>
Caso não exista um arquivo para este fim, crie o arquivo `tf_03_provider.tf` com o conteúdo abaixo:

```hcl
#==================================================================
# provider.tf - Script de definicao do Provider
#==================================================================

provider "aws" {
  region = var.account_region

  default_tags {
    tags = var.default_tags
  }
}
```

### Passo 4

O script abaixo será responsável por criar o Security Group.<br>
Crie um arquivo no padrão `tf_NN_security-group.tf` e adicione:

```hcl
#==================================================================
# security-group.tf - Script de chamada do modulo Security Group
#==================================================================

module "security-group" {
  source   = "git@github.com:MameliTech/aws_security_group.git"
  for_each = var.security-group

  foundation_squad           = var.foundation_squad
  foundation_application     = var.foundation_application
  foundation_environment     = var.foundation_environment
  foundation_role            = var.foundation_role
  rn_squad                   = var.rn_squad
  rn_application             = var.rn_application
  rn_environment             = var.rn_environment
  default_tags               = var.default_tags
  rn_role                    = each.value.rn_role
  resource_type_abbreviation = each.value.resource_type_abbreviation
  ingress                    = each.value.ingress
}
```

### Passo 5

O script abaixo será responsável por gerar os Outputs dos recursos criados.<br>
Crie um arquivo no padrão `tf_99_outputs.tf` e adicione:

```hcl
#==================================================================
# outputs.tf - Script para geracao de Outputs
#==================================================================

output "all_outputs" {
  description = "All outputs"
  value       = module.security-group
}
```

### Passo 6

Adicione uma pasta env com os arquivos `dev.tfvars`, `hml.tfvars` e `prd.tfvars`. Em cada um destes arquivos você irá informar os valores das variáveis que o módulo utiliza.

Segue um exemplo do conteúdo de um arquivo `tfvars`:

```hcl
#==================================================================
# <dev/hml/prd>.tfvars - Arquivo de definicao de Valores de Variaveis
#==================================================================

#------------------------------------------------------------------
# Provider
#------------------------------------------------------------------
account_region = "us-east-1"


#------------------------------------------------------------------
# Data Source
#------------------------------------------------------------------
foundation_squad       = "devops"
foundation_application = "sap"
foundation_environment = "dev"
foundation_role        = "sample"


#------------------------------------------------------------------
# Resource Nomenclature & Tags
#------------------------------------------------------------------
rn_squad       = "devops"
rn_application = "sapfi"
rn_environment = "dev"

default_tags = {
  "N_projeto" : "DevOps Lab"                                                            # Nome do projeto
  "N_ccusto_ti" : "Mameli-TI-2025"                                                      # Centro de Custo TI
  "N_ccusto_neg" : "Mameli-Business-2025"                                               # Centro de Custo Negocio
  "N_info" : "Para maiores informacoes procure a Mameli Tech - consultor@mameli.com.br" # Informacoes adicionais
  "T_funcao" : "Security Group padrao"                                                  # Funcao do recurso
  "T_versao" : "1.0"                                                                    # Versao de provisionamento do ambiente
  "T_backup" : "nao"                                                                    # Descritivo se sera realizado backup automaticamente dos recursos provisionados
}


#------------------------------------------------------------------
# Security Group
#------------------------------------------------------------------
security-group = {
  "security-group" = {
    rn_role                    = "mainsg01"
    resource_type_abbreviation = "ecr"
    ingress = [{
      description = "Permite trafego para ICMP"
      from_port   = -1
      to_port     = -1
      protocol    = "ICMP"
      cidr_blocks = ["10.0.0.0/16", "177.81.79.205/32", "201.46.20.152/32", "187.122.62.27/32", "189.37.67.15/32", "187.106.82.74/32", "44.204.215.169/32"]
    }]
  }
}
```

## Requisitos

| Nome | Versão |
|------|---------|
| [Terraform]() | >= 1.10.5 |
| [AWS]() | ~= 5.84.0 |

<br>

## Recursos

| Nome | Tipo |
|------|------|
| [aws_iam_policy]() | resource |
| [aws_security_group]() | resource |


<br>

## Entradas do módulo

 A tabela a seguir segue a ordem presente no código.

| Nome | Descrição | Tipo | Default | Obrigatório |
|------|-----------|------|---------|:-----------:|
| [foundation_squad]() | Nome da squad definada na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_application]() | Nome da aplicação definada na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_environment]() | Acrônimo do ambiente definido na VPC que será utilizada. | `string` | `null` | sim |
| [foundation_role]() | Função definada na VPC que será utilizada. | `string` | `null` | sim |
| [rn_squad]() | Nome da squad. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_application]() | Nome da aplicação. Limitado a 8 caracteres. | `string` | `null` | sim |
| [rn_environment]() | Acrônimo do ambiente (dev/hml/prd/devops). Limitado a 6 caracteres. | `string` | `null` | sim |
| [rn_role]() | Função do recurso. Limitado a 8 caracteres. | `string` | `null` | sim |
| [default_tags]() | TAGs padrão que serão adicionadas em todos os recursos. | `map(string)` | `null` | sim |
| [vpc_security_group_ids]() | O valor padrão é null. Se a variável for diferente de null, o recurso não será criado. | `list(string)` | `null` | sim |
| [resource_type_abbreviation]() | Abreviação do tipo de recurso que utilizá o Security Group. | `string` | "" | sim |
| [ingress]() | Define as regras entrada do grupo de segurança. Descrição conforme a liberação, porta, protocolo e range de IP. | `list(object)` | `null` | sim |

<br><br><hr>

<div align="right">

<strong> Data da última versão: &emsp; 10/03/2025 </strong>

</div>
