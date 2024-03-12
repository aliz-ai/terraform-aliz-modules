import json
import subprocess as sp

# !!! needs update for imput
plan = open("plan.json", "r")
plan_json = json.load(plan)
plan.close()

class Resource:
  def __init__(self, type, tf_id, gcp_id):
    self.type = type
    self.tf_id = tf_id
    self.gcp_id = gcp_id

project_name = [
  "google_compute_backend_service",
  "google_compute_managed_ssl_certificate",
  "google_compute_ssl_policy",
  "google_compute_target_http_proxy",
  "google_compute_target_https_proxy",
  "google_compute_url_map",
  "google_compute_global_address",
  "google_compute_network",
  "google_sql_database_instance",
]

project_region_name = [
  "google_compute_subnetwork",
  "google_vpc_access_connector",
]

def get_resources(input):
  import_resources = []
  if "resources" in input:
    for resource in input["resources"]:

      # cloudbuild trigger
      if resource["type"] == "google_cloudbuild_trigger":
        id = sp.run("gcloud builds triggers describe {} --project={} --format=\"value(id)\"".format(resource["values"]["name"], resource["values"]["project"]), shell=True, capture_output=True).stdout.strip().decode("utf-8")
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}".format(resource["values"]["project"],id)))

      # secret manager secret
      elif resource["type"] == "google_secret_manager_secret":
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}".format(resource["values"]["project"], resource["values"]["secret_id"])))

      # resource with project/name format
      elif resource["type"] in project_name:
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}".format(resource["values"]["project"], resource["values"]["name"])))

      # resource with project/region/name format
      elif resource["type"] in project_region_name:
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}/{}".format(resource["values"]["project"], resource["values"]["region"], resource["values"]["name"])))

      # redis instance
      elif resource["type"] == "google_redis_instance":
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}/{}".format(resource["values"]["project"], resource["values"]["location_id"], resource["values"]["name"])))

      # project
      elif resource["type"] == "google_project":
        import_resources.append(Resource(resource["type"], resource["address"], resource["values"]["project_id"]))

      # project service
      elif resource["type"] == "google_project_service":
        import_resources.append(Resource(resource["type"], resource["address"], "{}/{}".format(resource["values"]["project"], resource["values"]["service"])))

      # regional network endpoint group
      elif resource["type"] == "google_compute_region_network_endpoint_group":
        import_resources.append(Resource(resource["type"], resource["address"], resource["values"]["id"]))
  if "child_modules" in input:
      for child_module in input["child_modules"]:
        import_resources.extend(get_resources(child_module))
  return import_resources

def import_resources(resource_map):
  import_commands = []
  for resource in resource_map:
    import_commands.append("import {{\n id = \"{}\"\n to = {}\n}}".format(resource.gcp_id, resource.tf_id))
  return import_commands

def write_import_commands(commands_list):
  with open("import.tf", "w") as outfile:
    outfile.write("#!/bin/bash\n")
    outfile.writelines((str(command) + "\n\n" for command in commands_list))

values_to_import = get_resources(plan_json["planned_values"]["root_module"])
import_commands = import_resources(values_to_import)
write_import_commands(import_commands)
