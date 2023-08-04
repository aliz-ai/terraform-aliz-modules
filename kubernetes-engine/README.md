## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_container_cluster.cluster](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/container_cluster) | resource |
| [google_kms_crypto_key.cluster-key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key) | resource |
| [google_kms_crypto_key_iam_binding.crypto_key](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_crypto_key_iam_binding) | resource |
| [google_kms_key_ring.cluster-keyring](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/kms_key_ring) | resource |
| [google_project_iam_member.nodes_service_account_roles](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/project_iam_member) | resource |
| [google_service_account.nodes](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/service_account) | resource |
| [google_project.service_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_ip_range_pods"></a> [ip\_range\_pods](#input\_ip\_range\_pods) | Pods secondary range | `string` | n/a | yes |
| <a name="input_ip_range_services"></a> [ip\_range\_services](#input\_ip\_range\_services) | Secondary range for services | `string` | n/a | yes |
| <a name="input_master_range"></a> [master\_range](#input\_master\_range) | IP range for GKE control plane /28 | `string` | n/a | yes |
| <a name="input_max_cpu"></a> [max\_cpu](#input\_max\_cpu) | Maximum number of CPUs (for cluster autoscaler) | `number` | `32` | no |
| <a name="input_max_memory"></a> [max\_memory](#input\_max\_memory) | Maximum cluster memory GB (for cluster autoscaler) | `number` | `128` | no |
| <a name="input_max_nvidia_k80"></a> [max\_nvidia\_k80](#input\_max\_nvidia\_k80) | Maximum no. of K80 GPUs (for cluster autoscaler) | `number` | `1` | no |
| <a name="input_max_nvidia_p100"></a> [max\_nvidia\_p100](#input\_max\_nvidia\_p100) | Maximum no. of P100 GPUs (for cluster autoscaler) | `number` | `1` | no |
| <a name="input_max_nvidia_v100"></a> [max\_nvidia\_v100](#input\_max\_nvidia\_v100) | Maximum no. of V100 GPUs (for cluster autoscaler) | `number` | `1` | no |
| <a name="input_metering_dataset_id"></a> [metering\_dataset\_id](#input\_metering\_dataset\_id) | BQ dataset id for metering | `string` | n/a | yes |
| <a name="input_network"></a> [network](#input\_network) | Nodes network (name or link) | `string` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | Cluster project | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Cluster region | `string` | n/a | yes |
| <a name="input_subnetwork"></a> [subnetwork](#input\_subnetwork) | Nodes subnet (name or link) | `string` | n/a | yes |

## Outputs

No outputs.
