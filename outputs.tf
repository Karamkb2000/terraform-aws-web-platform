output "alb_dns_name" {
  value = module.web.alb_dns_name
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "db_endpoint" {
  value = module.data.db_endpoint
}

output "assets_bucket" {
  value = module.storage.bucket_name
}
