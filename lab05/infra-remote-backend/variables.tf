# commons
variable "workload" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.workload))
    error_message = "Workload group name is not valid."
  }
  default = "mgmt"
}

variable "environments" {
  type = set(string)
  validation {
      condition = alltrue([
        for environment in var.environments : can(regex("^[\\w-]+$", environment))
      ])
    error_message = "At least one environment name is not valid."
  }
  default = ["dev", "prod"]
}

variable "location" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.location))
    error_message = "Location group name is not valid."
  }
  default = "westeurope"
}

variable "team_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.team_name))
    error_message = "Workload group name is not valid."
  }
  default = "vl"
}