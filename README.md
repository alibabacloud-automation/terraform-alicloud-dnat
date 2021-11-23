Terraform Module for creating several DNAT entries for Nat Gateway on  Alibaba Cloud.    
terraform-alicloud-dnat
===========================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/blob/master/README-CN.md)

Terraform module used to create several [DNAT entries](https://www.alibabacloud.com/help/doc-detail/65170.htm) for an existing Nat Gateway on Alibaba Cloud. 
The DNAT function which maps a public IP address to an ECS instance so that the ECS instance can provide Internet services.

These types of resources are supported:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## Usage

```hcl
// Create vpc and vswitches
module "vpc" {
  source = "alibaba/vpc/alicloud"
  
  # ... omitted
}
// Create ecs instance
module "ecs-instance" {
  source = "alibaba/ecs-instance/alicloud"

  # ... omitted
}
// create a new nat gateway
module "nat" {
  source = "terraform-alicloud-modules/nat-gateway/alicloud"

  # ... omitted
}

module "complete" {
  source = "terraform-alicloud-modules/dnat/alicloud"


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

## Notes
From the version v1.1.0, the module has removed the following `provider` setting:

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/dnat"
}
```

If you still want to use the `provider` setting to apply this module, you can specify a supported version, like 1.0.0:

```hcl
module "dnat" {
  source  = "terraform-alicloud-modules/dnat/alicloud"
  version = "1.0.0"
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  create  = true
  // ...
}
```

If you want to upgrade the module to 1.1.0 or higher in-place, you can define a provider which same region with
previous region:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
}
module "dnat" {
  source  = "terraform-alicloud-modules/dnat/alicloud"
  create  = true
  // ...
}
```
or specify an alias provider with a defined region to the module using `providers`:

```hcl
provider "alicloud" {
  region  = "cn-hangzhou"
  profile = "Your-Profile-Name"
  alias   = "hz"
}
module "dnat" {
  source    = "terraform-alicloud-modules/dnat/alicloud"
  providers = {
    alicloud = alicloud.hz
  }
  create    = true
  // ...
}
```

and then run `terraform init` and `terraform apply` to make the defined provider effect to the existing module state.

More details see [How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

## Terraform versions

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0 |

Submit Issues
-------------

If you have any problems when using this module, please opening a [provider issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new) and let us know.

**Note:** There does not recommend to open an issue on this repo.

Authors
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

Reference
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)


