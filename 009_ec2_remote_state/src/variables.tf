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
  type        = list(number)
  description = "List of ingress ports"
  default     = [80, 443]
}