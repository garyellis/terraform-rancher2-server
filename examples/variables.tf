## infrastructure
variable "name" {
  description = "a unique identifier applied to all resources. Is the name prefix when more than one instance of a specific resource type is created"
  type        = string
  default     = "rancher"
}

variable "dns_domain_name" {
  description = "the route53 dns domain name"
  type        = string
}

variable "dns_zone_id" {
  description = "the route53 zone id"
  type        = string
}

variable "ami_id" {
  type    = string
  default = ""
}

variable "key_name" {
  default = ""
  type    = string
}

variable "etcd_instance_type" {
  description = "The etcd nodes ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "etcd_subnets" {
  description = "The etcd nodes subnet ids"
  type        = list(string)
  default     = []
}

variable "controlplane_instance_type" {
  description = "The controlplane nodes ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "controlplane_subnets" {
  description = "The controlplane nodes subnet ids"
  type        = list(string)
  default     = []
}

variable "worker_instance_type" {
  description = "The worker nodes ec2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "worker_subnets" {
  description = "The worker nodes subnet ids"
  type        = list(string)
  default     = []
}

variable "vpc_id" {
  type = string

}

variable "apiserver_lb_subnets" {
  description = "The apiserver lb subnet ids"
  type        = list(string)
  default     = []
}

variable "ingress_lb_subnets" {
  description = "The ingress lb subnet ids"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags on all taggable resources"
  type        = map(string)
  default     = {}
}

## rke-cluster
variable "ssh_user" {
  description = "The ssh user"
  type        = string
  default     = "centos"
}

variable "ssh_key_path" {
  description = "The ssh key path"
  type        = string
  default     = "/Users/gary/.ssh/id_rsa"
}

variable "default_registry" {
  description = "override the rke system images default registry"
  type        = string
  default     = ""
}
