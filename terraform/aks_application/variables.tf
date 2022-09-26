variable "workload" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.workload))
    error_message = "Workload group name is not valid."
  }
  default = "mgmt"
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

variable "sql_user" {
  type = string
}

variable "sql_password" {
  type = string
}

variable "sqldb_name" {
  type = string
}

variable "sql_fqdn" {
  type = string
}

variable "aks_name" {
  type = string
}

variable "aks_resource_group" {
  type = string
}

variable "applications" {
  type = map(object({
    cpu_max         = string,
    cpu_min         = string,
    image           = string,
    ip_address_type = string,
    memory_max      = string,
    memory_min      = string,
    name            = string,
    port            = number,
    protocol        = string,
    replicas        = number
  }))
  default = {
    app01 = {
      name            = "app01"
      ip_address_type = "Public"
      image           = "app01image"
      cpu_min         = "200m"
      memory_min      = "256Mi"
      cpu_max         = "0.5"
      memory_max      = "512Mi"
      port            = 80
      protocol        = "TCP"
      replicas        = 1
    }
  }
}