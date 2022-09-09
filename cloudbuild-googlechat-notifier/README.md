# Google Chat notifier for Cloud Build triggers

A terraform module that bundles the [Google-maintained notifier code](https://github.com/GoogleCloudPlatform/cloud-build-notifiers/tree/master/googlechat), deployed based on [their installation instructions](https://cloud.google.com/build/docs/configuring-notifications/configure-googlechat#configuring_google_chat_notifications).

A rough summary of the solution:
* Cloud Build publishes build status updates to the Pub/Sub topic named `cloud-builds`, if it exists in the same projects (and IAM permissions are okay)
* A Cloud Run service subscribes to these notifications, filters the events and publishes to the configured webhook.
* The configuration file is pushed to Cloud Storage
* The webhook URL is created manually on Google Chat and it is stored in Secret Manager.