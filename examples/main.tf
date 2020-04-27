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
  source = "../"

  cluster_name                = var.name
  etcd_node_addresses         = module.aws-infrastructure.etcd_node_ips
  controlplane_node_addresses = module.aws-infrastructure.controlplane_node_ips
  worker_node_addresses       = module.aws-infrastructure.worker_node_ips
  apiserver_sans              = list(module.aws-infrastructure.apiserver_fqdn)
  ssh_user                    = var.ssh_user
  ssh_key_path                = var.ssh_key_path
}

module "" {

}
