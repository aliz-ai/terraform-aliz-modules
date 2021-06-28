# CloudSQL Scheduled Export

## Overview

This terraform module create several resources which will be used to automate the export of data from a CloudSQL instance.

## Requirements

## Required Resources

1. CloudSQL Instance
2. Cloud Storage Bucket
    * Cloud Storage permission allow Cloud SQL in item 1 to do the following actions: `storage.objects.create` and `storage.objects.create`.

### Installation Dependencies

### Enable APIs

* Cloud SQL Admin API: `sqladmin.googleapis.com`
* Cloud Scheduler : `cloudscheduler.googleapis.com`
* Cloud Function : `cloudfunctions.googleapis.com`
* Cloud PubSub : `pubsub.googleapis.com`
* Cloud Storage : `storage.googleapis.com`
* Cloud Build API : `cloudbuild.googleapis.com`

### Create App Engine Application


## Architecture Design


