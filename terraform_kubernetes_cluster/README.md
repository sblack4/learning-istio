# istio_cluster

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.14.0 |
| azurerm | >= 2.36.0 |

## Providers

| Name | Version |
|------|---------|
| azuread | n/a |
| azurerm | >= 2.36.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_admin\_group\_display\_name | Display name of cluster admins AAD group | `string` | n/a | yes |
| env | Physical (software defined) grouping for infrastructure | `string` | n/a | yes |
| kubernetes\_version | Version of Kubernetes. Retrieve list with `az aks get-versions -l eastus` | `string` | n/a | yes |
| owner | Maintainer of infrastructure | `string` | n/a | yes |
| subscription\_id | ID of subscription where resources will reside | `string` | n/a | yes |
| location | Primary region used for project | `string` | `"eastus"` | no |
| tags | Resource Tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| aks\_admin\_password | AKS admin password |
| aks\_admin\_username | AKS admin username |
| aks\_client\_certificate | AKS cluster client certificate |
| aks\_client\_key | AKS cluster client key |
| aks\_cluster\_ca\_certificate | AKS Cluster CA Cert |
| aks\_cluster\_name | AKS Cluster Name |
| aks\_cluster\_resource\_group\_name | AKS Cluster resource\_group\_name |
| aks\_host | AKS APIServer Hostname |
| aks\_kubeconfig\_raw | Raw admin kubeconfig for AKS |
| aks\_msi\_id | Managed Service Identity for AKS ID |
| virtual\_network\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
