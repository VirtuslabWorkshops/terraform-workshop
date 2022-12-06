variable "name_prefix" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "enable_public_ip" {
  type = bool
  default = true
}