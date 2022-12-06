variable "location" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.location))
    error_message = "Location group name is not valid."
  }
  default = "westeurope"
}

variable "environment" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.environment))
    error_message = "Environment name is not valid."
  }
  default = "dev"
}

variable "rg_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.rg_name))
    error_message = "Resource group name is not valid."
  }
  default = "rg-vl-westeurope-dev"
}

variable "sa_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.sa_name))
    error_message = "Storage Account name is not valid."
  }
  default = "savlwesteuropedev"
}

variable "sa_depends_on" {
  type    = any
  default = []
}