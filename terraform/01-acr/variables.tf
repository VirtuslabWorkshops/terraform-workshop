variable "resource_group_name" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.resource_group_name))
    error_message = "Resource group name is not valid."
  }
}
variable "location" {
  type = string
  validation {
    condition     = can(regex("^[\\w-]+$", var.location))
    error_message = "Argo CD namespace is not valid."
  }
}