module "nginx" {
  source = "../module"

  aws_region    = var.aws_region
  instance_type = var.instance_type
  purpose       = var.purpose
  unique_id     = var.unique_id
}

output "nginx_url" {
  value       = module.nginx.nginx_url
  description = "URL to the nginx Server"
}

output "monitoring_url" {
  value       = module.nginx.monitoring_url
  description = "URL to monitor the nginx Server"
}

output "instance_id" {
  value       = module.nginx.instance_id
  description = "The EC2 instance ID"
}
