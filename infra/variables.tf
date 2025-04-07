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

variable "eu_ami" {
  description = "amazon linux 2023 - eu eu-west-3 ami"
  type        = string
  default     = "ami-0446057e5961dfab6"
}

variable "instance_type" {
  description = "ec2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "all_ip" {
  description = "all ip adresses"
  type        = string
  default     = "0.0.0.0/0"
}