locals {
  dnat_table_id = var.dnat_table_id != "" ? var.dnat_table_id : var.nat_gateway_id != "" ? concat(data.alicloud_nat_gateways.this.gateways[*].dnat_table_id, [""])[0] : ""
}

data "alicloud_nat_gateways" "this" {
  ids = var.nat_gateway_id != "" ? [var.nat_gateway_id] : null
}

resource "alicloud_forward_entry" "this" {
  count = var.create ? length(var.entries) : 0

  forward_table_id   = local.dnat_table_id
  forward_entry_name = lookup(var.entries[count.index], "name", format("tf-dnat-entry%3d", count.index + 1))
  ip_protocol        = lookup(var.entries[count.index], "ip_protocol", "any")
  external_ip        = lookup(var.entries[count.index], "external_ip", var.external_ip)
  external_port      = lookup(var.entries[count.index], "external_port", "any")
  internal_ip        = lookup(var.entries[count.index], "internal_ip", var.internal_ip)
  # Default to external_port
  internal_port = lookup(var.entries[count.index], "internal_port", lookup(var.entries[count.index], "external_port", "any"))
}