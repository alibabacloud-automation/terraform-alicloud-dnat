Terraform Module for creating several DNAT entries for Nat Gateway on  Alibaba Cloud.    
terraform-alicloud-dnat
===========================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/blob/master/README-CN.md)

Terraform module used to create several [DNAT entries](https://www.alibabacloud.com/help/doc-detail/65170.htm) for an existing Nat Gateway on Alibaba Cloud. 
The DNAT function which maps a public IP address to an ECS instance so that the ECS instance can provide Internet services.

These types of resources are supported:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## Terraform versions

For Terraform 0.12 and Alicloud Provider 1.56.0+.

## Usage

```hcl
// Create vpc and vswitches
module "vpc" {
  source = "alibaba/vpc/alicloud"
  region = var.region
  # ... omitted
}
// Create ecs instance
module "ecs-instance" {
  source = "alibaba/ecs-instance/alicloud"
  region = var.region
  # ... omitted
}
// create a new nat gateway
module "nat" {
  source = "terraform-alicloud-modules/nat-gateway/alicloud"
  region = var.region
  # ... omitted
}

module "complete" {
  source = "terraform-alicloud-modules/dnat/alicloud"
  region = var.region

  create        = true
  dnat_table_id = module.nat.this_dnat_table_id

  # Default public ip, which will be used for all dnat entries.
  external_ip = module.nat.this_eip_ips[0]

  # Open to CIDRs blocks
  entries = [
    {
      name         = "dnat-443-8443"
      ip_protocol = "tcp"
      external_port = "443"
      internal_port = "8443"
      internal_ip = module.ecs-instance.this_private_ip.0
      external_ip      = module.nat.this_eip_ips[1]
    },
    {
      name         = "dnat-80-80"
      ip_protocol = "tcp"
      external_port = "80"
      internal_ip = module.ecs-instance.this_private_ip.1
    }
  ]
}
```

## Examples

* [Complete example](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/tree/master/examples/complete) shows all available parameters to configure dnat entry.

Submit Issues
-------------

If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com)

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)


