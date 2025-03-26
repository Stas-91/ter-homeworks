module "vpc_dev" {
  source       = "./modules/vpc"
  network_name = var.vpc_configs.dev.network_name
  subnets      = var.vpc_configs.dev.subnets
}

module "vpc_prod" {
  source       = "./modules/vpc"
  network_name = var.vpc_configs.prod.network_name
  subnets      = var.vpc_configs.prod.subnets
}

data "template_file" "cloudinit" {
  template = file("./cloud-init.tpl")
  vars = {
    username  = var.vm_common.username
    ssh_key1  = var.vms_ssh_root_key
    packages  = jsonencode(var.vm_common.packages)
    runcmd    = var.vm_common.runcmd
  }
}

module "marketing_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=f96532a"
  env_name       = var.vm_instances.marketing.env_name
  network_id     = module.vpc_dev.network_id
  subnet_zones   = var.vm_instances.marketing.subnet_zones
  subnet_ids     = [module.vpc_dev.subnet_ids[var.vm_instances.marketing.subnet_zones[0]]]
  instance_name  = var.vm_instances.marketing.instance_name
  instance_count = var.vm_instances.marketing.instance_count
  image_family   = var.vm_common.image_family
  public_ip      = var.vm_instances.marketing.public_ip
  labels         = var.vm_instances.marketing.labels
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_common.serial_port_enable
  }
}

module "analytics_vm" {
  source         = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=f96532a"
  env_name       = var.vm_instances.analytics.env_name
  network_id     = module.vpc_dev.network_id
  subnet_zones   = var.vm_instances.analytics.subnet_zones
  subnet_ids     = [module.vpc_dev.subnet_ids[var.vm_instances.analytics.subnet_zones[0]]]
  instance_name  = var.vm_instances.analytics.instance_name
  instance_count = var.vm_instances.analytics.instance_count
  image_family   = var.vm_common.image_family
  public_ip      = var.vm_instances.analytics.public_ip
  labels         = var.vm_instances.analytics.labels
  metadata = {
    user-data          = data.template_file.cloudinit.rendered
    serial-port-enable = var.vm_common.serial_port_enable
  }
}

module "mysql_cluster" {
  source       = "./modules/mysql_cluster"
  cluster_name = var.mysql_config.cluster_name
  network_id   = module.vpc_prod.network_id
  ha           = var.mysql_config.ha
  security_group_ids = [yandex_vpc_security_group.mysql_sg.id]
}

module "mysql_db_user" {
  source        = "./modules/mysql_db_user"
  cluster_id    = module.mysql_cluster.cluster_id
  database_name = var.mysql_config.database_name
  username      = var.mysql_config.username
  password      = var.mysql_config.password
  user_roles    = var.mysql_config.user_roles
}

resource "random_string" "unique_id" {
  length  = var.random_string_config.length
  upper   = var.random_string_config.upper
  lower   = var.random_string_config.lower
  numeric = var.random_string_config.numeric
  special = var.random_string_config.special
}

module "s3" {
  source      = "git::https://github.com/terraform-yc-modules/terraform-yc-s3.git?ref=e4017d7"
  bucket_name = "${var.s3_config.bucket_prefix}-${random_string.unique_id.result}"
  max_size    = var.s3_config.max_size
  versioning  = var.s3_config.versioning
}

resource "vault_kv_secret_v2" "example" {
  mount     = var.vault_config.mount
  name      = var.vault_config.name
  data_json = jsonencode(var.vault_config.data)
}