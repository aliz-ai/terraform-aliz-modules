locals {
  alert_filters = {
    # add P1 alerts
    "org_root_permission_grant"            = "protoPayload.methodName:\"AdminService.assignRole\" OR\\nprotoPayload.methodName:\"AdminService.addPrivilege\"",
    "super_admin_auth"                     = "protoPayload.authenticationInfo.principalEmail=\"${local.admin_email}\"\\nprotoPayload.methodName:\"LoginService.loginSuccess\"",
    "cloud_identity_config_change"         = "protoPayload.methodName:\"AdminService.changeApplicationSetting\"",
    "api_client_access_change"             = "protoPayload.methodName:\"AdminService.authorizeApiClientAccess\" OR\\nprotoPayload.methodName:\"AdminService.removeApiClientAccess\"",
    "org_admin_role_grant"                 = "protoPayload.methodName:\"SetIamPolicy\"\\nprotoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/resourcemanager.organizationAdmin\"",
    "add_member_to_admin_group"            = "protoPayload.methodName:\"AdminService.addGroupMember\"\\nprotoPayload.metadata.event.parameter.value=\"${local.admin_group_email}\"",
    "delete_super_admin"                   = "protoPayload.methodName:\"AdminService.deleteUser\"\\nprotoPayload.metadata.event.parameter.value=\"${local.admin_email}\"",
    "remove_member_from_admin_group"       = "protoPayload.methodName:\"AdminService.removeGroupMember\"",
    "service_account_or_key_create"        = "protoPayload.methodName:\"SetIamPolicy\"\\nprotoPayload.serviceData.policyDelta.bindingDeltas.action=\"ADD\"\\nprotoPayload.serviceData.policyDelta.bindingDeltas.member:\".gserviceaccount.com\"\\n(protoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/owner\" OR\\nprotoPayload.serviceData.policyDelta.bindingDeltas.role=\"roles/editor\")",
    "public_access_on_resource"            = "protoPayload.methodName=\"storage.setIamPermissions\" AND\\n(protoPayload.serviceData.policyDelta.bindingDeltas.member=\"allUsers\" OR\\nprotoPayload.serviceData.policyDelta.bindingDeltas.member=\"allAuthenticatedUsers\")",
    "add_ssh_key_to_metadata"              = "protoPayload.methodName:\"instances.setMetadata\"\\nprotoPayload.metadata.instanceMetadataDelta.addedMetadataKeys=\"ssh-keys\"",
    "org_or_folder_iam_change"             = "protoPayload.methodName:\"SetIamPolicy\"\\n(protoPayload.resourceName:\"organizations\" OR\\nprotoPayload.resourceName:\"folders\")",
    "scc_findings_notifiaction"            = "resource.type=\"threat_detector\"\\njsonPayload.detectionPriority=\"HIGH\"",
    "org_log_sinks_modification"           = "(protoPayload.methodName:\"CreateSink\" OR\\nprotoPayload.methodName:\"UpdateSink\" OR\\nprotoPayload.methodName:\"DeleteSink\") AND\\nprotoPayload.resourceName:\"organizations\"",
    "pubsub_destination_modification"      = "protoPayload.methodName:\"Publisher.DeleteTopic\" OR\\nprotoPayload.methodName:\"Subscriber.DeleteSubscription\"",
    "enable_api_for_unaproved_service"     = "protoPayload.methodName:\"Publisher.DeleteTopic\" OR\\nprotoPayload.methodName:\"Subscriber.DeleteSubscription\"",
    "modified_org_policy"                  = "protoPayload.methodName:\"SetOrgPolicy\"",
    "resource_created_outside_pipeline"    = "(protoPayload.methodName=\"storage.buckets.create\" OR protoPayload.methodName:\"instances.insert\") AND NOT protoPayload.authenticationInfo.principalEmail=\" terraform@[project_id].iam.gserviceaccount.com\"",
    "packet_mirroring_enabled_or_modified" = "resource.type=\"gce_packet_mirroring\" AND\\n(protoPayload.methodName:\"packetMirrorings.patch\" OR\\nprotoPayload.methodName:\"packetMirrorings.create\")",
    "public_firewall_rule_created"         = "protoPayload.methodName:\"firewalls\" AND protoPayload.request.sourceRanges=\"0.0.0.0/0\"",
    "sensitive_ports_opened_to_public"     = "protoPayload.methodName:\"firewalls\" AND\\n(protoPayload.request.alloweds.ports=(3306 OR 389 OR 2049 OR 111 OR 22)) AND protoPayload.resourceOriginalState.sourceRanges=\"0.0.0.0/0\"",
    "new_external_route_added"             = "protoPayload.methodName:\"routes.insert\"\\nprotoPayload.request.nextHopGateway:\"global/gateways/default-internet-gateway\"",
    "network_logs_disabled"                = "protoPayload.request.enableFlowLogs=false OR\\nprotoPayload.resourceOriginalState.logConfig.enable=false",
    "data_access_logs_disabled"            = "protoPayload.serviceData.policyDelta.auditConfigDeltas.action=\"REMOVE\"\\nprotoPayload.methodName:\"SetIamPolicy\"",
  }
  admin_email       = var.super_admin_auth.enabled ? var.super_admin_auth.admin_email : ""
  admin_group_email = var.add_member_to_admin_group.enabled ? var.add_member_to_admin_group.admin_group_email : ""
}