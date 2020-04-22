output "api_url" {
  value = format("https://%s.%s", var.dns_name, var.dns_domain_name)
}

# here until we add in aws ssm parameters or vault kv v2
output "admin_token" {
  value     = rancher2_bootstrap.admin.token
  sensitive = true
}
