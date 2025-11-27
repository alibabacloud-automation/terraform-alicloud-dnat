Terraform Module for creating several DNAT entries for Nat Gateway on  Alibaba Cloud.
terraform-alicloud-dnat
=======================

English | [简体中文](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/blob/master/README-CN.md)

Terraform module used to create several [DNAT entries](https://www.alibabacloud.com/help/doc-detail/65170.htm) for an existing Nat Gateway on Alibaba Cloud. 
The DNAT function which maps a public IP address to an ECS instance so that the ECS instance can provide Internet services.

These types of resources are supported:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## Usage

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=terraform-alicloud-modules%3A%3Adnat&spm=docs.m.terraform-alicloud-modules.dnat&intl_lang=EN_US" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_alicloud"></a> [alicloud](#provider\_alicloud) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [alicloud_forward_entry.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/resources/forward_entry) | resource |
| [alicloud_nat_gateways.this](https://registry.terraform.io/providers/hashicorp/alicloud/latest/docs/data-sources/nat_gateways) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_create"></a> [create](#input\_create) | Whether to create dnat entries. If true, the 'entries' should be set. | `bool` | `true` | no |
| <a name="input_dnat_table_id"></a> [dnat\_table\_id](#input\_dnat\_table\_id) | The dnat table id to use on all dnat entries. | `string` | `""` | no |
| <a name="input_entries"></a> [entries](#input\_entries) | A list of entries to create. Each item valid keys: 'name'(default to a string with prefix 'tf-dnat-entry' and numerical suffix), 'ip\_protocol'(default to 'any'), 'external\_ip'(if not, use root parameter 'external\_ip'), 'external\_port'(default to 'any'), 'internal\_ip'(required), 'internal\_port'(default to the 'external\_port'). | `list(map(string))` | `[]` | no |
| <a name="input_external_ip"></a> [external\_ip](#input\_external\_ip) | The public ip address to use on all dnat entries. | `string` | `""` | no |
| <a name="input_internal_ip"></a> [internal\_ip](#input\_internal\_ip) | The internal ip, must a private ip. | `string` | `""` | no |
| <a name="input_nat_gateway_id"></a> [nat\_gateway\_id](#input\_nat\_gateway\_id) | The id of a nat gateway used to fetch the 'dnat\_table\_id'. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_this_forward_entry_id"></a> [this\_forward\_entry\_id](#output\_this\_forward\_entry\_id) | The ID of the forward entrys |
<!-- END_TF_DOCS -->

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