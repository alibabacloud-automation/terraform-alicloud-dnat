#variables for ecs
system_disk_size = 60

#variables for nat gateway
specification = "Middle"
period        = 2

# New EIP parameters
eip_bandwidth = 10
eip_period    = 2

#variables for alicloud_dnat_entry
entries = [
  {
    name          = "update-tf-dnat"
    ip_protocol   = "udp"
    external_port = "90"
    internal_port = "9090"
  }
]