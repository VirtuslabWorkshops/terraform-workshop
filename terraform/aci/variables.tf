variable "workload" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.workload))
    error_message = "Workload group name is not valid."
  }
}

variable "team_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.team_name))
    error_message = "Team_name group name is not valid."
  }
}

variable "environment" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.environment))
    error_message = "Environment group name is not valid."
  }
}

variable "location" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.location))
    error_message = "Location group name is not valid."
  }
}

variable "frontendimage" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9](([a-z0-9-[^-])){1,61}[a-z0-9]$", var.frontendimage))
    error_message = "Container name is not valid."
  }
}

variable "backendimage" {
  type = string
  validation {
    condition     = can(regex("^[a-z0-9](([a-z0-9-[^-])){1,61}[a-z0-9]$", var.backendimage))
    error_message = "Container name is not valid."
  }
}