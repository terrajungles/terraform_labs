variable "project" {
  type = string
  default = "terratest"
}

variable "greeting_message" {
  type = string
}

variable "environment" {
  type = string
  default = "test"
}

variable "ingress_ports" {
  type        = list(number)
  description = "List of ingress ports"
  default     = [80, 443]
}