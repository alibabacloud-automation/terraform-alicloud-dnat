variable "region" {
  default = "cn-hangzhou"
}

provider "alicloud" {
  region = var.region
}

#############################################################
# Data sources to get VPC and vswitch details
#############################################################

data "alicloud_vpcs" "default" {
  is_default = true
}

data "alicloud_images" "ubuntu" {
  name_regex = "ubuntu_18"
}

module "group" {
  source = "alibaba/security-group/alicloud"
  region = var.region

  name   = "dnat-service"
  vpc_id = data.alicloud_vpcs.default.ids.0
}

module "ecs-instance" {
  source = "alibaba/ecs-instance/alicloud"
  region = var.region

  number_of_instances = 2

  name                        = "my-ecs-cluster"
  use_num_suffix              = true
  instance_type               = "ecs.mn4.small"
  image_id                    = data.alicloud_images.ubuntu.ids.0
  vswitch_ids                 = [data.alicloud_vpcs.default.vpcs.0.vswitch_ids[0]]
  security_group_ids          = [module.group.this_security_group_id]
  associate_public_ip_address = false

  system_disk_category = "cloud_ssd"
  system_disk_size     = 50
}
#############################################################
# Using module to create a new nat gateway and bind two eip
#############################################################
module "nat" {
  source = "terraform-alicloud-modules/nat-gateway/alicloud"
  region = var.region

  name   = "nat-foo"
  vpc_id = data.alicloud_vpcs.default.ids.0
  create = true

  // create eips and bind them with nat
  create_eip    = true
  number_of_eip = 2
  eip_name      = "for-dnat"
}

################################################
# Dnat entries with complete set of arguments
################################################
module "complete" {
  source = "../../"
  region = var.region

  create        = true
  dnat_table_id = module.nat.this_dnat_table_id

  # Default public ip, which will be used for all dnat entries.
  external_ip = module.nat.this_eip_ips[0]

  # Open to CIDRs blocks
  entries = [
    {
      name          = "dnat-443-8443"
      ip_protocol   = "tcp"
      external_port = "443"
      internal_port = "8443"
      internal_ip   = module.ecs-instance.this_private_ip.0
      external_ip   = module.nat.this_eip_ips[1]
    },
    {
      name          = "dnat-80-80"
      ip_protocol   = "tcp"
      external_port = "80"
      internal_ip   = module.ecs-instance.this_private_ip.1
    }
  ]
}
