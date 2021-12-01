import base64
import logging
import json

from datetime import datetime
from httplib2 import Http

from googleapiclient import discovery
from googleapiclient.errors import HttpError
from oauth2client.client import GoogleCredentials

system_databases = [
    "information_schema", 
    "performance_schema",
    "mysql",
    "sys"
]

def main(event, context):

    pubsub_message = json.loads(base64.b64decode(event['data']).decode('utf-8'))

    # For local testing
    # pubsub_message = {
    #     'dbs' : [], # [ "sakila" ],
    #     'instance' : "",
    #     'project' : "",
    #     'gs' : "",
    #     'suffix' : "export"
    # }

    project = pubsub_message['project']
    gs = pubsub_message['gs']

    credentials = GoogleCredentials.get_application_default()

    service = discovery.build('sqladmin', 'v1', http=credentials.authorize(Http()), cache_discovery=False)

    if pubsub_message['instance'] == "":
        instances = get_list_of_instances(service, project, pubsub_message)

        for item in instances:

            instance = item['instance_name']
            export_bucket = item['export_bucket']

            uri = get_export_object_uri(export_bucket,
                pubsub_message['project'],
                instance,
                pubsub_message['suffix']
            )
            db_list = get_list_of_databases(service, project, instance)

            instances_export_request_body = {
                "exportContext": {
                    "kind": "sql#exportContext",
                    "fileType": "SQL",
                    "uri": uri,
                    "databases": db_list
                }
            }

            export_dbs(service, project, instance,instances_export_request_body)
    else:
        instance = pubsub_message['instance']

        uri = get_export_object_uri(pubsub_message['gs'],
            pubsub_message['project'],
            instance,
            pubsub_message['suffix']
        )

        if pubsub_message['dbs'] == []:
            db_list = get_list_of_databases(service, project, instance)
        else:
            db_list = pubsub_message['dbs']

        instances_export_request_body = {
            "exportContext": {
                "kind": "sql#exportContext",
                "fileType": "SQL",
                "uri": uri,
                "databases": db_list
            }
        }

        export_dbs(service, project, instance, instances_export_request_body)


def get_list_of_databases(service, project, instance):
    try:
        request = service.databases().list(
            project=project,
            instance=instance,
        )
        response = request.execute()
        db_list = []
        for item in response["items"]:
            if item["name"] not in system_databases:
                db_list.append(item["name"])
    except HttpError as err:
        logging.error("Could not list database. Reason: {}".format(err))
    else:
        logging.info("Listing Database: {}".format(db_list))

def export_dbs(service, project, instance, instances_export_request_body):
    try:
        request = service.instances().export(
            project=project,
            instance=instance,
            body=instances_export_request_body
        )
        response = request.execute()
    except HttpError as err:
        logging.error("Could NOT run backup. Reason: {}".format(err))
    else:
        logging.info("Backup task status: {}".format(response))


def get_export_object_uri(bucket, project, instance, suffix):
    now = datetime.now().strftime("%Y%m%d%H%M")  # format timestamp: YearMonthDayHourMinute
    parameters = {
        'bucket': bucket,
        'project': project,
        'instance': instance,
        'datetime': now,
        'suffix': suffix
    }
    uri = "gs://{bucket}/backup/{project}/{instance}/" + ("{suffix}-" if suffix else "") + "{datetime}.gz"
    return uri.format_map(parameters)

def get_list_of_instances(service, project, pubsub_message):

    filter = 'settings.userLabels.backup:enabled'
    instance_list = []

    try:
        request = service.instances().list(
            project=project,
            filter=filter
        )
        response = request.execute()

        if len(response["items"]) > 0:
            for item in response["items"]:
                instance_item = {
                    "instance_name": item["name"],
                    "export_bucket": item["settings"]["userLabels"]["backup_bucket"]
                }
                instance_list.append(instance_item)
    except HttpError as err:
        logging.error("Could not list CloudSQL Instances. Reason: {}".format(err))
    else:
        logging.info("Listing CloudSQL Instances: {}".format(instance_list))

    return instance_list


if __name__ == "__main__":
    main()
