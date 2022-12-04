variable "environment" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.environment))
    error_message = "Environment name is not valid."
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

variable "workload" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.workload))
    error_message = "Workload name is not valid."
  }
  default = "vl"
}

variable "rg_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.rg_name))
    error_message = "Resource group name is not valid."
  }
  default = "vl"
}

variable "sa_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.sa_name))
    error_message = "Storage account name is not valid."
  }
  default = "savl"
}

