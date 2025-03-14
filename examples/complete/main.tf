data "alicloud_zones" "default" {
}

data "alicloud_images" "default" {
  name_regex = "ubuntu_18"
}

data "alicloud_instance_types" "default" {
  availability_zone    = data.alicloud_zones.default.zones[0].id
  cpu_core_count       = 2
  memory_size          = 8
  instance_type_family = "ecs.g6"
}

module "vpc" {
  source  = "alibaba/vpc/alicloud"
  version = "~>1.11.0"

  create             = true
  vpc_cidr           = "172.16.0.0/16"
  vswitch_cidrs      = ["172.16.0.0/21"]
  availability_zones = [data.alicloud_zones.default.zones[0].id]
}

module "security_group" {
  source  = "alibaba/security-group/alicloud"
  version = "~>2.4.0"

  vpc_id = module.vpc.this_vpc_id
}

module "ecs-instance" {
  source  = "alibaba/ecs-instance/alicloud"
  version = "~>2.12.0"

  number_of_instances = 1

  instance_type               = data.alicloud_instance_types.default.instance_types[0].id
  image_id                    = data.alicloud_images.default.images[0].id
  vswitch_ids                 = [module.vpc.this_vswitch_ids[0]]
  security_group_ids          = [module.security_group.this_security_group_id]
  associate_public_ip_address = false
  system_disk_category        = "cloud_ssd"
  system_disk_size            = var.system_disk_size
}

resource "alicloud_nat_gateway" "this" {
  vpc_id               = module.vpc.this_vpc_id
  vswitch_id           = module.vpc.this_vswitch_ids[0]
  nat_type             = var.nat_type
  specification        = var.specification
  payment_type         = "PayAsYouGo"
  internet_charge_type = "PayByLcu"
  period               = var.period
}

module "eip" {
  source  = "terraform-alicloud-modules/eip/alicloud"
  version = "~>2.1.0"

  number_of_eips       = 1
  bandwidth            = var.eip_bandwidth
  internet_charge_type = "PayByTraffic"
  instance_charge_type = "PostPaid"
  period               = var.eip_period
  isp                  = "BGP"
}

resource "alicloud_eip_association" "this" {
  allocation_id = module.eip.this_eip_id[0]
  instance_id   = alicloud_nat_gateway.this.id
}

# Dnat entries with complete set of arguments
module "complete" {
  source = "../../"

  create = true

  nat_gateway_id = alicloud_nat_gateway.this.id
  dnat_table_id  = alicloud_nat_gateway.this.forward_table_ids
  external_ip    = module.eip.this_eip_address[0]
  internal_ip    = module.ecs-instance.this_private_ip[0]
  entries        = var.entries

}
