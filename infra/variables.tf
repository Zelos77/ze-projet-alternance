variable "region" {
  description = "region aws"
  type        = string
  default     = "eu-west-3"
}

variable "az_euw" {
  description = "list of availability zone EU-WEST"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b", "eu-west"]
}