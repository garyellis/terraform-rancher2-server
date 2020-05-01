resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

resource "null_resource" "depends_on_tf_module_aws_route53_zone" {
  triggers = {
    value = length(module.lb_dns.private_zone_id)
  }
}


provider "kubernetes" {
  host                   = var.api_server_url
  client_certificate     = var.client_cert
  client_key             = var.client_key
  cluster_ca_certificate = var.ca_crt
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    host                   = var.api_server_url
    client_certificate     = var.client_cert
    client_key             = var.client_key
    cluster_ca_certificate = var.ca_crt
    load_config_file       = false
  }
}

provider "rancher2" {
  alias     = "bootstrap"
  api_url   = format("https://%s.%s", var.dns_name, var.dns_domain_name)
  insecure  = true
  bootstrap = true
}

provider "rancher2" {
  alias     = "admin"
  api_url   = format("https://%s.%s", var.dns_name, var.dns_domain_name)
  insecure  = true
  token_key = rancher2_bootstrap.admin.token
}


data "helm_repository" "rancher_stable" {
  name = "rancher-stable"
  url  = var.rancher_server_chart_stable
}

data "helm_repository" "rancher_latest" {
  name = "rancher-latest"
  url  = var.rancher_server_chart_stable
}

locals {
  alias_records_count = var.create_route53_record ? 1 : 0
}

module "lb_dns" {
  source = "github.com/garyellis/tf_module_aws_route53_zone"

  create_zone = false
  name        = var.dns_domain_name
  alias_records = [
    { name = var.dns_name, aws_dns_name = var.ingress_lb_dns_name, zone_id = var.ingress_lb_zone_id, evaluate_target_health = "true" },
  ]
  alias_records_count = local.alias_records_count
  zone_id             = var.dns_zone_id
}


resource "kubernetes_namespace" "cattle_system" {
  metadata {
    name        = "cattle-system"
    annotations = var.annotations
    labels      = var.labels
  }
}


## additional trusted CAs
resource "kubernetes_secret" "tls_ca_additional" {
  count = length(var.tls_ca_additional) > 0 ? 1 : 0
  metadata {
    name      = "tls-ca-additional"
    namespace = "cattle-system"
  }

  data = {
    "ca-additional.pem" = file(var.tls_ca_additional)
  }

  depends_on = [
    kubernetes_namespace.cattle_system
  ]
}

locals {
  ## https://rancher.com/docs/rancher/v2.x/en/installation/options/chart-options/
  values_yaml = <<EOF
---
rancherImage:  ${var.rancher_image}
rancherImageTag: ${var.rancher_image_tag}
hostname: ${format("%s.%s", var.dns_name, var.dns_domain_name)}
privateCA: ${var.private_ca}
%{if length(var.tls_ca_additional) > 0}
additionalTrustedCAs: true
%{endif~}
%{if var.use_bundled_system_chart}
systemDefaultRegistry: "${var.system_default_registry}"
%{endif~}
useBundledSystemChart: "${var.use_bundled_system_chart}"
ingress:
  tls:
    source: ${var.ingress_tls_source}

EOF

}

resource "helm_release" "rancher" {
  repository   = ! var.use_latest_chart_repo ? data.helm_repository.rancher_stable.metadata[0].name : data.helm_repository.rancher_latest.metadata[0].name
  name         = "rancher"
  chart        = "rancher"
  version      = var.rancher_chart_version
  namespace    = "cattle-system"
  reuse_values = true

  values = list(local.values_yaml)

  depends_on = [
    null_resource.module_depends_on,
    null_resource.depends_on_tf_module_aws_route53_zone,
    kubernetes_namespace.cattle_system
  ]
}

resource "rancher2_bootstrap" "admin" {
  provider  = rancher2.bootstrap
  password  = var.admin_password
  telemetry = false
  depends_on = [
    helm_release.rancher
  ]
}

resource "rancher2_catalog" "catalogs" {
  count = length(var.catalogs)

  provider    = rancher2.admin
  name        = lookup(var.catalogs[count.index], "name")
  description = lookup(var.catalogs[count.index], "description", null)
  url         = lookup(var.catalogs[count.index], "url")
  username    = lookup(var.catalogs[count.index], "username", null)
  password    = lookup(var.catalogs[count.index], "password", null)
  version     = lookup(var.catalogs[count.index], "version", "helm_v3")
}
