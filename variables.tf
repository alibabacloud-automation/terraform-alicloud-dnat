

#################
# Dnat Entries
#################
variable "create" {
  description = "Whether to create dnat entries. If true, the 'entries' should be set."
  type        = bool
  default     = true
}

variable "entries" {
  description = "A list of entries to create. Each item valid keys: 'name'(default to a string with prefix 'tf-dnat-entry' and numerical suffix), 'ip_protocol'(default to 'any'), 'external_ip'(if not, use root parameter 'external_ip'), 'external_port'(default to 'any'), 'internal_ip'(required), 'internal_port'(default to the 'external_port')."
  type        = list(map(string))
  default     = []
}

variable "nat_gateway_id" {
  description = "The id of a nat gateway used to fetch the 'dnat_table_id'."
  type        = string
  default     = ""
}

variable "dnat_table_id" {
  description = "The dnat table id to use on all dnat entries."
  type        = string
  default     = ""
}

variable "external_ip" {
  description = "The public ip address to use on all dnat entries."
  type        = string
  default     = ""
}

variable "internal_ip" {
  description = "The internal ip, must a private ip."
  type        = string
  default     = ""
}