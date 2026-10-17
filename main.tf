
data "aws_availability_zone" "available" {
  state = "available"
  
}

module "network" {
    source = "./modules/network"

    project = var.project
    vpc_cidr = var.vpc_cidr
    az-names = slice(data.aws_availability_zones.azs.available.names, 0, var.az_count)
  
}