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
| [google_monitoring_alert_policy.uptime-check-alert-policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_uptime_check_config.https](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_uptime_check_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_duration"></a> [duration](#input\_duration) | Duration of the uptime check | `list(string)` | <pre>[<br>  "60s"<br>]</pre> | no |
| <a name="input_host"></a> [host](#input\_host) | Hostname or IP adress of the check | `string` | n/a | yes |
| <a name="input_monitored_project_id"></a> [monitored\_project\_id](#input\_monitored\_project\_id) | project\_id of the monitored resource | `string` | n/a | yes |
| <a name="input_notification_channels"></a> [notification\_channels](#input\_notification\_channels) | List of notification channels | `list(string)` | n/a | yes |
| <a name="input_project"></a> [project](#input\_project) | the ID of the project in wich the resource belongs | `string` | n/a | yes |

## Outputs

No outputs.