# Terraform, Kubectl, Helm, Helmfile and Helm-diff plugin cloud builder

This builder creates an image based on gcloud-slim that includes Terraform, Kubectl, Helm, Helmfile and Helm-diff plugin.

The Google and Google-Beta providers are pre-installed in the image, they are placed to /bin/ directory.

### Building this builder
This builder is automatically created if you use the Cloudbuild Terraform module.
By default, the included versions of Terraform, Terraform Google providers, Kubectl, Helm and Helmfile are the default values indicated below, but by using Terraform module you can override them by setting your custom values of the given variables.

If you would like to build manually, run the following command in this directory.
```sh
$ gcloud builds submit --config=cloudbuild.yaml
```
In this case the default values of Terraform, Terraform Google providers, Kubectl, Helm and Helmfile can be overridden by setting your custom value of the given substitution.

### Enable APIs
* `artifactregistry.googleapis.com`
* `cloudbuild.googleapis.com`

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | n/a |
| <a name="provider_google-beta"></a> [google-beta](#provider\_google-beta) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google-beta_google_artifact_registry_repository.tf-image-repo](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository) | resource |
| [google-beta_google_artifact_registry_repository_iam_member.member](https://registry.terraform.io/providers/hashicorp/google-beta/latest/docs/resources/google_artifact_registry_repository_iam_member) | resource |
| [null_resource.cloudbuild_terraform_builder](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [google_project.cloudbuild_project](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_builder_image_name"></a> [builder\_image\_name](#input\_builder\_image\_name) | Name of the builder image | `string` | `"tf-helm-helmfile-kubectl-image"` | no |
| <a name="input_cloudbuild_project_id"></a> [cloudbuild\_project\_id](#input\_cloudbuild\_project\_id) | The project id where the pipelines and repos should be created | `string` | n/a | yes |
| <a name="input_default_region"></a> [default\_region](#input\_default\_region) | Default region to create resources where applicable. | `string` | n/a | yes |
| <a name="input_google_beta_provider_version"></a> [google\_beta\_provider\_version](#input\_google\_beta\_provider\_version) | Version of the google-beta provider | `string` | `"4.1"` | no |
| <a name="input_google_provider_version"></a> [google\_provider\_version](#input\_google\_provider\_version) | Version of the google provider | `string` | `"4.1"` | no |
| <a name="input_helm_sha256"></a> [helm\_sha256](#input\_helm\_sha256) | sha256 for default helm version. | `string` | `"096e30f54c3ccdabe30a8093f8e128dba76bb67af697b85db6ed0453a2701bf9"` | no |
| <a name="input_helm_version"></a> [helm\_version](#input\_helm\_version) | Default helm version. | `string` | `"v3.7.0"` | no |
| <a name="input_helmfile_version"></a> [helmfile\_version](#input\_helmfile\_version) | Default helmfile version. | `string` | `"v0.142.0"` | no |
| <a name="input_kubectl_version"></a> [kubectl\_version](#input\_kubectl\_version) | Default kube version. | `string` | `"v1.22.4"` | no |
| <a name="input_terraform_validator_release"></a> [terraform\_validator\_release](#input\_terraform\_validator\_release) | Default terraform-validator release. | `string` | `"v0.4.0"` | no |
| <a name="input_terraform_version"></a> [terraform\_version](#input\_terraform\_version) | Default terraform version. | `string` | `"1.0.11"` | no |
| <a name="input_terraform_version_sha256sum"></a> [terraform\_version\_sha256sum](#input\_terraform\_version\_sha256sum) | sha256sum for default terraform version. | `string` | `"eeb46091a42dc303c3a3c300640c7774ab25cbee5083dafa5fd83b54c8aca664"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_builder_image"></a> [builder\_image](#output\_builder\_image) | n/a |
| <a name="output_google_artifact_repo_name"></a> [google\_artifact\_repo\_name](#output\_google\_artifact\_repo\_name) | n/a |
<!-- END_TF_DOCS -->