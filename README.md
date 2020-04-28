# terraform-rancher2-server
Deploy rancher server on an kubernetes cluster. This module implements the following:

* create the cattle-system namespace
* deploy the rancher server helm chart
* set the rancher admin password

## Requirements

terraform v0.12

## Providers

| Name | Version |
|------|---------|
| helm | n/a |
| kubernetes | n/a |
| null | n/a |
| rancher2.bootstrap | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| admin\_password | n/a | `string` | `"welcome1"` | no |
| annotations | a map of annotationss applied to cattle-system namespace | `map(string)` | `{}` | no |
| api\_server\_url | the kube apiserver url | `string` | n/a | yes |
| ca\_crt | the apiserver cacert | `string` | n/a | yes |
| client\_cert | the apiserver client certificate | `string` | n/a | yes |
| client\_key | the apiserver client key | `string` | n/a | yes |
| create\_route53\_record | n/a | `bool` | n/a | yes |
| dns\_domain\_name | n/a | `string` | n/a | yes |
| dns\_name | n/a | `string` | n/a | yes |
| dns\_zone\_id | n/a | `string` | n/a | yes |
| ingress\_lb\_dns\_name | The load balancer dns name | `string` | n/a | yes |
| ingress\_lb\_zone\_id | The ingress load balancer zone id | `string` | n/a | yes |
| ingress\_tls\_source | the rancher server ingress source. Can be rancher, letsEncrypt or secret | `string` | `"rancher"` | no |
| labels | a map of labels applied to resources | `map(string)` | `{}` | no |
| module\_depends\_on | one or more modules to wait for before converging this module | `list(string)` | `[]` | no |
| private\_ca | when rancher server cert is signed by private ca, set the tls ca in rancher namespace | `string` | `"false"` | no |
| rancher\_chart\_version | n/a | `string` | `"v2.3.6"` | no |
| rancher\_image | n/a | `string` | `"rancher/rancher"` | no |
| rancher\_image\_tag | n/a | `string` | `"v2.3.6"` | no |
| rancher\_server\_chart\_latest | n/a | `string` | `"https://releases.rancher.com/server-charts/latest"` | no |
| rancher\_server\_chart\_stable | n/a | `string` | `"https://releases.rancher.com/server-charts/stable"` | no |
| system\_default\_registry | Rancher server will pull from this registry when provisioning clusters | `string` | `null` | no |
| use\_bundled\_system\_chart | enable when rancher server does not have internet access | `bool` | `false` | no |
| use\_latest\_chart\_repo | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| admin\_token | |
| api\_url | n/a |
