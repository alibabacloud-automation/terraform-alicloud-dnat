output "this_nat_gateway_id" {
  description = "The ID of the nat gateway id"
  value       = module.nat.this_nat_gateway_id
}

output "this_dnat_table_id" {
  description = "The ID of the dnat table id"
  value       = module.nat.this_dnat_table_id
}
output "this_eip_ids" {
  description = "The ID of EIPs"
  value       = module.nat.this_eip_ips
}

