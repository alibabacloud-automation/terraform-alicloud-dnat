output "this_nat_gateway_id" {
  description = "The ID of the nat gateway id"
  value       = alicloud_nat_gateway.this.id
}

output "this_dnat_table_id" {
  description = "The ID of the dnat table id"
  value       = alicloud_nat_gateway.this.forward_table_ids
}

output "this_eip_ids" {
  description = "The ID of EIPs"
  value       = module.eip.this_eip_id
}