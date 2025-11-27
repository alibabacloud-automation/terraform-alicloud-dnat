terraform-alicloud-dnat
=======================

本 Module 用于在阿里云的 Nat 网关下批量添加[Dnat条目](https://www.alibabacloud.com/help/doc-detail/65170.htm)。
DNAT功能将NAT网关上的公网IP映射给ECS实例使用，使ECS实例能够提供互联网服务。

本 Module 支持创建以下资源:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## 用法

<div style="display: block;margin-bottom: 40px;"><div class="oics-button" style="float: right;position: absolute;margin-bottom: 10px;">
  <a href="https://api.aliyun.com/terraform?source=Module&activeTab=document&sourcePath=terraform-alicloud-modules%3A%3Adnat&spm=docs.m.terraform-alicloud-modules.dnat" target="_blank">
    <img alt="Open in AliCloud" src="https://img.alicdn.com/imgextra/i1/O1CN01hjjqXv1uYUlY56FyX_!!6000000006049-55-tps-254-36.svg" style="max-height: 44px; max-width: 100%;">
  </a>
</div></div>

支持设置待创建的资源
```hcl
// 创建vpc和vswitch
module "vpc" {
  source = "alibaba/vpc/alicloud"
  # ... omitted
}
// 创建 ecs instance
module "ecs-instance" {
  source = "alibaba/ecs-instance/alicloud"
  # ... omitted
}
// 创建一个 nat gateway
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

## 示例

* [完整使用示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/tree/master/examples/complete) 展示所有可配置的参数。

## 注意事项
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显式设置：

```hcl
provider "alicloud" {
  profile                 = var.profile != "" ? var.profile : null
  shared_credentials_file = var.shared_credentials_file != "" ? var.shared_credentials_file : null
  region                  = var.region != "" ? var.region : null
  skip_region_validation  = var.skip_region_validation
  configuration_source    = "terraform-alicloud-modules/dnat"
}
```

如果你依然想在Module中使用这个 provider 配置，你可以在调用Module的时候，指定一个特定的版本，比如 1.0.0:

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

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显式定义一个相同Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显式指定这个provider：

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

定义完provider之后，运行命令 `terraform init` 和 `terraform apply` 来让这个provider生效即可。

更多provider的使用细节，请移步[How to use provider in the module](https://www.terraform.io/docs/language/modules/develop/providers.html#passing-providers-explicitly)

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

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by Alibaba Cloud Terraform Team(terraform@alibabacloud.com).

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)