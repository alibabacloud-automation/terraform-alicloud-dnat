#ECS
variable "system_disk_size" {
  description = "Size of the system disk, measured in GiB."
  type        = number
  default     = 50
}

#NAT-GATEWAY
variable "nat_type" {
  description = "The type of NAT gateway."
  type        = string
  default     = "Enhanced"
}

variable "specification" {
  description = "The specification of nat gateway."
  type        = string
  default     = "Small"
}

variable "period" {
  description = "The charge duration of the PrePaid nat gateway, in month."
  type        = number
  default     = 1
}

#EIP
variable "eip_bandwidth" {
  description = "Maximum bandwidth to the elastic public network, measured in Mbps (Mega bit per second)."
  type        = number
  default     = 5
}

variable "eip_period" {
  description = "The duration that you will buy the EIP, in month."
  type        = number
  default     = 1
}

# Dnat Entries
variable "entries" {
  description = "A list of entries to create. Each item valid keys: 'name'(default to a string with prefix 'tf-dnat-entry' and numerical suffix), 'ip_protocol'(default to 'any'), 'external_ip'(if not, use root parameter 'external_ip'), 'external_port'(default to 'any'), 'internal_ip'(required), 'internal_port'(default to the 'external_port')."
  type        = list(map(string))
  default = [
    {
      name          = "tf-dnat"
      ip_protocol   = "tcp"
      external_port = "80"
      internal_port = "8080"
    }
  ]
}