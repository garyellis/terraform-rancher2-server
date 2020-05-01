variable "module_depends_on" {
  description = "one or more modules to wait for before converging this module"
  type        = list(string)
  default     = []
}

variable "api_server_url" {
  description = "the kube apiserver url"
  type        = string
}

variable "client_cert" {
  description = "the apiserver client certificate"
  type        = string
}

variable "client_key" {
  description = "the apiserver client key"
  type        = string
}

variable "ca_crt" {
  description = "the apiserver cacert"
  type        = string
}

variable "dns_zone_id" {
  type = string
}

variable "dns_domain_name" {
  type = string
}

variable "dns_name" {
  type = string
}

variable "create_route53_record" {
  type = bool
}

variable "ingress_lb_dns_name" {
  description = "The load balancer dns name"
  type        = string
}

variable "ingress_lb_zone_id" {
  description = "The ingress load balancer zone id"
  type        = string
}

variable "rancher_server_chart_stable" {
  type    = string
  default = "https://releases.rancher.com/server-charts/stable"
}

variable "rancher_server_chart_latest" {
  type    = string
  default = "https://releases.rancher.com/server-charts/latest"
}

variable "use_latest_chart_repo" {
  type    = bool
  default = false
}

variable "rancher_chart_version" {
  type    = string
  default = "v2.3.6"
}

variable "annotations" {
  description = "a map of annotationss applied to cattle-system namespace"
  type        = map(string)
  default     = {}
}

variable "labels" {
  description = "a map of labels applied to resources"
  type        = map(string)
  default     = {}
}

variable "rancher_image" {
  type    = string
  default = "rancher/rancher"
}

variable "rancher_image_tag" {
  type    = string
  default = "v2.3.6"
}

variable "system_default_registry" {
  description = "Rancher server will pull from this registry when provisioning clusters"
  type        = string
  default     = null
}

variable "use_bundled_system_chart" {
  description = "enable when rancher server does not have internet access"
  type        = bool
  default     = false
}

variable "ingress_tls_source" {
  description = "the rancher server ingress source. Can be rancher, letsEncrypt or secret"
  type        = string
  default     = "rancher"
}

variable "private_ca" {
  description = "when rancher server cert is signed by private ca, set the tls ca in rancher namespace"
  type        = string
  default     = "false"
}

variable "admin_password" {
  type    = string
  default = "welcome1"
}

variable "tls_ca_additional" {
  description = "The local path to an additional trusted cas file"
  type        = string
  default     = ""
}

variable "catalogs" {
  description = "a list of helm repo catalogs added to rancher server"
  type        = list(map(string))
  default     = []
}
