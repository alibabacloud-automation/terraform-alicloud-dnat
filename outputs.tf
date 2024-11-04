output "this_forward_entry_id" {
  description = "The ID of the forward entrys"
  value       = alicloud_forward_entry.this[*].id
}
