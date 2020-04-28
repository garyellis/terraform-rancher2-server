provider "aws" {
  ignore_tags {
    key_prefixes = [
      "kubernetes.io/cluster/"
    ]
  }
}

module "aws-infrastructure" {
  source = "github.com/garyellis/terraform-aws-k8s-infrastructure"

  name   = var.name
  tags   = var.tags
  vpc_id = var.vpc_id

  # load balancer and lb dns cfg
  dns_domain_name      = var.dns_domain_name
  dns_zone_id          = var.dns_zone_id
  apiserver_lb_subnets = var.apiserver_lb_subnets
  ingress_lb_subnets   = var.ingress_lb_subnets

  # ec2 instances options
  ami_id                   = var.ami_id
  key_name                 = var.key_name
  toggle_allow_all_egress  = true
  toggle_allow_all_ingress = true

  # etcd nodes
  etcd_nodes_count   = 3
  etcd_instance_type = var.etcd_instance_type
  etcd_subnets       = var.etcd_subnets

  # controlplane nodes
  controlplane_nodes_count   = 2
  controlplane_instance_type = var.controlplane_instance_type
  controlplane_subnets       = var.controlplane_subnets

  # worker nodes
  worker_nodes_count   = 2
  worker_instance_type = var.worker_instance_type
  worker_subnets       = var.worker_subnets
}

module "k8s_cluster" {
  source = "github.com/garyellis/terraform-rke-cluster"

  cluster_name                         = var.name
  etcd_node_addresses                  = module.aws-infrastructure.etcd_node_private_dns
  etcd_node_internal_addresses         = module.aws-infrastructure.etcd_node_ips
  controlplane_node_addresses          = module.aws-infrastructure.controlplane_node_private_dns
  controlplane_node_internal_addresses = module.aws-infrastructure.controlplane_node_ips
  worker_node_addresses                = module.aws-infrastructure.worker_node_private_dns
  worker_node_internal_addresses       = module.aws-infrastructure.worker_node_ips
  apiserver_sans                       = list(module.aws-infrastructure.apiserver_fqdn)
  ssh_user                             = var.ssh_user
  ssh_key_path                         = var.ssh_key_path
  labels                               = var.tags
}

module "k8s_addons_terraform_sa" {
  source = "github.com/garyellis/terraform-k8s-addons//terraform-sa"

  api_server_url = module.aws-infrastructure.apiserver_host
  client_cert    = module.k8s_cluster.client_cert
  client_key     = module.k8s_cluster.client_key
  ca_crt         = module.k8s_cluster.ca_crt
}

module "k8s_addons_terraform_cert_manager" {
  source = "github.com/garyellis/terraform-k8s-addons//cert-manager"

  api_server_url       = module.aws-infrastructure.apiserver_host
  client_cert          = module.k8s_cluster.client_cert
  client_key           = module.k8s_cluster.client_key
  ca_crt               = module.k8s_cluster.ca_crt
  service_account_name = module.k8s_addons_terraform_sa.name
}

module "rancher_server" {
  source = "../"

  api_server_url = module.aws-infrastructure.apiserver_host
  client_cert    = module.k8s_cluster.client_cert
  client_key     = module.k8s_cluster.client_key
  ca_crt         = module.k8s_cluster.ca_crt

  create_route53_record = true
  dns_zone_id           = var.dns_zone_id
  dns_domain_name       = var.dns_domain_name
  dns_name              = format("%s-rancher", var.name)
  ingress_lb_zone_id    = module.aws-infrastructure.ingress_lb_zone_id
  ingress_lb_dns_name   = module.aws-infrastructure.ingress_lb_dns_name

  module_depends_on = [
    module.k8s_addons_terraform_cert_manager.chart_metadata[0].name
  ]
}
