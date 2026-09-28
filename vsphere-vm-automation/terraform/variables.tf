variable "vcenter_server" {
  type        = string
  description = "vCenter FQDN"
}

variable "vcenter_user" {
  type        = string
  description = "Service account used by Terraform"
}

variable "vcenter_pass" {
  type        = string
  description = "Service account password"
  sensitive   = true
}

variable "allow_unverified_ssl" {
  type        = bool
  default     = false
  description = "Set true only in a lab with self-signed certificates"
}

variable "datacenter" { type = string }
variable "cluster" { type = string }
variable "datastore" { type = string }
variable "network" { type = string }
variable "template" { type = string }

variable "vm_folder" {
  type        = string
  description = "VM folder path relative to the datacenter vm root"
}

variable "domain" {
  type    = string
  default = "example.local"
}

variable "dns_servers" {
  type = list(string)
}

variable "gateway" { type = string }

variable "netmask_bits" {
  type    = number
  default = 24
}

variable "vms" {
  description = "Map of VMs to create. Key = VM name."
  type = map(object({
    ip     = string
    cpus   = optional(number, 2)
    memory = optional(number, 4096)
  }))
}
