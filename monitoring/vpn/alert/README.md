# Google Cloud VPN Alert Module

## Overview

This module create several alert for Cloud VPN resources

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
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
| [google_monitoring_alert_policy.all_bgp_sessions_down](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.all_vpn_tunnels_down](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.bgp_session_down](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |
| [google_monitoring_alert_policy.vpn_tunnels_down](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/monitoring_alert_policy) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_all_bgp_sessions_down_documentation_content"></a> [all\_bgp\_sessions\_down\_documentation\_content](#input\_all\_bgp\_sessions\_down\_documentation\_content) | Documentation that is included with notifications and incidents related to this policy. | `string` | `"See docs"` | no |
| <a name="input_all_bgp_sessions_down_duration"></a> [all\_bgp\_sessions\_down\_duration](#input\_all\_bgp\_sessions\_down\_duration) | The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported. | `string` | `"180s"` | no |
| <a name="input_all_bgp_sessions_down_enabled"></a> [all\_bgp\_sessions\_down\_enabled](#input\_all\_bgp\_sessions\_down\_enabled) | Switch for All BGP Sessions Down Alert | `string` | `"true"` | no |
| <a name="input_all_bgp_sessions_down_notification_channels"></a> [all\_bgp\_sessions\_down\_notification\_channels](#input\_all\_bgp\_sessions\_down\_notification\_channels) | List of notification channels for All BGP Sessions Down Alert | `list(string)` | n/a | yes |
| <a name="input_all_vpn_tunnels_down_documentation_content"></a> [all\_vpn\_tunnels\_down\_documentation\_content](#input\_all\_vpn\_tunnels\_down\_documentation\_content) | Documentation that is included with notifications and incidents related to this policy. | `string` | `"See docs"` | no |
| <a name="input_all_vpn_tunnels_down_duration"></a> [all\_vpn\_tunnels\_down\_duration](#input\_all\_vpn\_tunnels\_down\_duration) | The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported. | `string` | `"180s"` | no |
| <a name="input_all_vpn_tunnels_down_enabled"></a> [all\_vpn\_tunnels\_down\_enabled](#input\_all\_vpn\_tunnels\_down\_enabled) | Switch for All VPN Tunnels Down Alert | `string` | `"true"` | no |
| <a name="input_all_vpn_tunnels_down_notification_channels"></a> [all\_vpn\_tunnels\_down\_notification\_channels](#input\_all\_vpn\_tunnels\_down\_notification\_channels) | List of notification channel for All VPN Tunnels Down aleert | `list(string)` | n/a | yes |
| <a name="input_bgp_session_down_documentation_content"></a> [bgp\_session\_down\_documentation\_content](#input\_bgp\_session\_down\_documentation\_content) | Documentation that is included with notifications and incidents related to this policy. | `string` | `"See docs"` | no |
| <a name="input_bgp_session_down_duration"></a> [bgp\_session\_down\_duration](#input\_bgp\_session\_down\_duration) | The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported. | `string` | `"900s"` | no |
| <a name="input_bgp_session_down_enabled"></a> [bgp\_session\_down\_enabled](#input\_bgp\_session\_down\_enabled) | Switch for BGP Session Down Alert | `string` | `"true"` | no |
| <a name="input_bgp_session_down_notification_channels"></a> [bgp\_session\_down\_notification\_channels](#input\_bgp\_session\_down\_notification\_channels) | List of notification channel for BGP Session Down alert | `list(string)` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | n/a | `string` | n/a | yes |
| <a name="input_vpn_tunnels_down_documentation_content"></a> [vpn\_tunnels\_down\_documentation\_content](#input\_vpn\_tunnels\_down\_documentation\_content) | Documentation that is included with notifications and incidents related to this policy. | `string` | `"See docs"` | no |
| <a name="input_vpn_tunnels_down_duration"></a> [vpn\_tunnels\_down\_duration](#input\_vpn\_tunnels\_down\_duration) | The amount of time that a time series must violate the threshold to be considered failing. Currently, only values that are a multiple of a minute--e.g., 0, 60, 120, or 300 seconds--are supported. | `string` | `"900s"` | no |
| <a name="input_vpn_tunnels_down_enabled"></a> [vpn\_tunnels\_down\_enabled](#input\_vpn\_tunnels\_down\_enabled) | Switch for VPN Tunnels Down Alert | `string` | `"true"` | no |
| <a name="input_vpn_tunnels_down_notification_channels"></a> [vpn\_tunnels\_down\_notification\_channels](#input\_vpn\_tunnels\_down\_notification\_channels) | List of notification channel for VPN Tunnels Down alert | `list(string)` | n/a | yes |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
