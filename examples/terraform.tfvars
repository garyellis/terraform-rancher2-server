# aws-infrastructure
name = "rke-cluster"
tags = {
  owner = "garyellis"
}
apiserver_lb_subnets = ["subnet-0af909e620fbeecec", "subnet-036ee547223d718c2", "subnet-0fd3ebb3ef93a32d9", ]
ingress_lb_subnets   = ["subnet-0af909e620fbeecec", "subnet-036ee547223d718c2", "subnet-0fd3ebb3ef93a32d9", ]
dns_domain_name      = "ews.works"
dns_zone_id          = "Z1NMUGQLTLR1UM"
vpc_id               = "vpc-090fb2bb569edbd85"

ami_id   = "ami-3ecc8f46"
key_name = "garyellis"

etcd_instance_type = "t3.medium"
etcd_subnets       = ["subnet-0af909e620fbeecec", "subnet-036ee547223d718c2", "subnet-0fd3ebb3ef93a32d9", ]

controlplane_instance_type = "t3.medium"
controlplane_subnets       = ["subnet-0af909e620fbeecec", "subnet-036ee547223d718c2", "subnet-0fd3ebb3ef93a32d9", ]

worker_instance_type = "t3.medium"
worker_subnets       = ["subnet-0af909e620fbeecec", "subnet-036ee547223d718c2", "subnet-0fd3ebb3ef93a32d9", ]


# k8s-cluster
ssh_key_path                = "/Users/gary/.ssh/id_rsa"
ssh_user                    = "centos"
