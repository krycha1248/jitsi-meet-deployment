variable "da_user" {
  type      = string
  sensitive = true
}

variable "da_pass" {
  type      = string
  sensitive = true
}

variable "da_host" {
  type      = string
  sensitive = true
}

variable "da_domain" {
  type      = string
  sensitive = true
}

variable "ssh_key" {
  type = string
  sensitive = true
}
