terraform-alicloud-dnat
=======================

本 Module 用于在阿里云的 Nat 网关下批量添加[Dnat条目](https://www.alibabacloud.com/help/doc-detail/65170.htm)。
DNAT功能将NAT网关上的公网IP映射给ECS实例使用，使ECS实例能够提供互联网服务。

本 Module 支持创建以下资源:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## 用法

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
本Module从版本v1.1.0开始已经移除掉如下的 provider 的显示设置：

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

如果你想对正在使用中的Module升级到 1.1.0 或者更高的版本，那么你可以在模板中显示定义一个系统过Region的provider：
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
或者，如果你是多Region部署，你可以利用 `alias` 定义多个 provider，并在Module中显示指定这个provider：

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

## Terraform 版本

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12.0 |
| <a name="requirement_alicloud"></a> [alicloud](#requirement\_alicloud) | >= 1.56.0 |

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

