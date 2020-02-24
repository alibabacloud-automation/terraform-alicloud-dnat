terraform-alicloud-dnat
=======================

本 Module 用于在阿里云的 Nat 网关下批量添加[Dnat条目](https://www.alibabacloud.com/help/doc-detail/65170.htm)。
DNAT功能将NAT网关上的公网IP映射给ECS实例使用，使ECS实例能够提供互联网服务。

本 Module 支持创建以下资源:

* [dnat_entry](https://www.terraform.io/docs/providers/alicloud/r/forward_entry.html)

## Terraform 版本

如果您正在使用 Terraform 0.12，Provider的版本 1.56.0+。

## 用法

支持设置待创建的资源
```hcl
// 创建vpc和vswitch
module "vpc" {
  source = "alibaba/vpc/alicloud"
  region = var.region
  # ... omitted
}
// 创建 ecs instance
module "ecs-instance" {
  source = "alibaba/ecs-instance/alicloud"
  region = var.region
  # ... omitted
}
// 创建一个 nat gateway
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

## 示例

* [完整使用示例](https://github.com/terraform-alicloud-modules/terraform-alicloud-dnat/tree/master/examples/complete) 展示所有可配置的参数。

提交问题
-------
如果在使用该 Terraform Module 的过程中有任何问题，可以直接创建一个 [Provider Issue](https://github.com/terraform-providers/terraform-provider-alicloud/issues/new)，我们将根据问题描述提供解决方案。

**注意:** 不建议在该 Module 仓库中直接提交 Issue。

作者
-------
Created and maintained by He Guimin(@xiaozhu36 heguimin36@163.com)

参考
---------
* [Terraform-Provider-Alicloud Github](https://github.com/terraform-providers/terraform-provider-alicloud)
* [Terraform-Provider-Alicloud Release](https://releases.hashicorp.com/terraform-provider-alicloud/)
* [Terraform-Provider-Alicloud Docs](https://www.terraform.io/docs/providers/alicloud/index.html)

