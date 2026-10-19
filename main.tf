data "aws_availability_zones" "available" {
  state = "available"
}

module "network" {
  source = "./modules/network"

  project  = var.project
  vpc_cidr = var.vpc_cidr
  az_names = slice(data.aws_availability_zones.available.names, 0, var.az_count)
}

module "security" {
  source = "./modules/security"

  project = var.project
  vpc_id  = module.network.vpc_id
}

module "storage" {
  source = "./modules/storage"

  project = var.project
}

module "data" {
  source = "./modules/data"

  project        = var.project
  db_subnet_ids  = module.network.database_subnet_ids
  db_sg_id       = module.security.db_sg_id
  db_username    = var.db_username
  db_password    = var.db_password
  instance_class = var.db_instance_class
  multi_az       = var.db_multi_az
}

module "web" {
  source = "./modules/web"

  project               = var.project
  vpc_id                = module.network.vpc_id
  instance_type         = var.instance_type
  public_subnet_ids     = module.network.public_subnet_ids
  private_subnet_ids    = module.network.private_subnet_ids
  alb_sg_id             = module.security.alb_sg_id
  web_sg_id             = module.security.web_sg_id
  instance_profile_name = module.storage.instance_profile_name
  s3_bucket             = module.storage.bucket_name
  db_endpoint           = module.data.db_endpoint
  min_size              = var.min_size
  max_size              = var.max_size
  desired_capacity      = var.desired_capacity
  cpu_target            = var.cpu_target
}
