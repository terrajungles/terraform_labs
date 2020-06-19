variable "project" {
  type = string
}

variable "greeting_message" {
  type = string
}

variable "environment" {
  type = string
}

variable "ingress_ports" {
  type = list(number)
  description = "List of ingress ports"
}

variable "ami" {
  type = string
}

variable "instance_count" {
  type = number
}

variable "tags" {
  type = map
}

variable "instance_tag_prefix" {
  type = string
}