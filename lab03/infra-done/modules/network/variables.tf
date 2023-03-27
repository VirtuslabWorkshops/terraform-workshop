variable "prefix" {
  type = string
}

variable "address_space" {
  type = string
}

variable "subnets" {
  type    = list(string)
  default = []
}