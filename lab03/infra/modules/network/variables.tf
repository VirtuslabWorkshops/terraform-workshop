variable "name_prefix" {
  type = string
}

variable "create_subnet" {
  type    = bool
  default = false
}

variable "address_space" {
  type = string
}

variable "subnets" {
  type = list(string)
  default = []
}