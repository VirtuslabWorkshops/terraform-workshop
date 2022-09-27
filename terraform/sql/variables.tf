variable "workload" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.workload))
    error_message = "Workload group name is not valid."
  }
  default = "vl"
}

variable "team_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.team_name))
    error_message = "Team_name group name is not valid."
  }
  default = "vl"
}

variable "environment" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.environment))
    error_message = "Environment group name is not valid."
  }
  default = "dev"
}

variable "location" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.location))
    error_message = "Location group name is not valid."
  }
  default = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "[optional] Additional tags."
  default     = {}
}

# kv
variable "sqldb_sku" {
  type = string
  validation {
    condition     = can(regex("^Basic|S0|P2$", var.sqldb_sku))
    error_message = "MSSQL database SKU can be Basic, S0, P2 only."
  }
  default = "Basic"
}

variable "key_vault_id" {}

variable "rg_name" {}
