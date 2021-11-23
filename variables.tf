#################
# Provider
#################
variable "region" {
  description = "(Deprecated from version 1.1.0) The region used to launch this module resources."
  type        = string
  default     = ""
}

variable "profile" {
  description = "(Deprecated from version 1.1.0) The profile name as set in the shared credentials file. If not set, it will be sourced from the ALICLOUD_PROFILE environment variable."
  type        = string
  default     = ""
}
variable "shared_credentials_file" {
  description = "(Deprecated from version 1.1.0) This is the path to the shared credentials file. If this is not set and a profile is specified, $HOME/.aliyun/config.json will be used."
  type        = string
  default     = ""
}

variable "skip_region_validation" {
  description = "(Deprecated from version 1.1.0) Skip static validation of region ID. Used by users of alternative AlibabaCloud-like APIs or users w/ access to regions that are not public (yet)."
  type        = bool
  default     = false
}

#################
# Dnat Entries
#################
variable "create" {
  description = "Whether to create dnat entries. If true, the 'entries' should be set."
  type        = bool
  default     = true
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

variable "entries" {
  description = "A list of entries to create. Each item valid keys: 'name'(default to a string with prefix 'tf-dnat-entry' and numerical suffix), 'ip_protocol'(default to 'any'), 'external_ip'(if not, use root parameter 'external_ip'), 'external_port'(default to 'any'), 'internal_ip'(required), 'internal_port'(default to the 'external_port')."
  type        = list(map(string))
  default     = []
}

variable "external_ip" {
  description = "The public ip address to use on all dnat entries."
  type        = string
  default     = ""
}

