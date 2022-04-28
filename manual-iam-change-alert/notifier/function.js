/* 
  Copyright 2019 Google LLC

  Licensed under the Apache License, Version 2.0 (the "License");
  you may not use this file except in compliance with the License.
  You may obtain a copy of the License at

      https://www.apache.org/licenses/LICENSE-2.0

  Unless required by applicable law or agreed to in writing, software
  distributed under the License is distributed on an "AS IS" BASIS,
  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  See the License for the specific language governing permissions and
  limitations under the License.
 */

const Buffer = require('safe-buffer').Buffer;
const request = require('request');
const isodate = require('isodate');

/**
 * Pushes an Event to a Webhook whenever a disk snapshot is taken successfully.
 *
 * Expects a PubSub message with JSON-formatted event data.
 *
 * @param {object} event Cloud Function PubSub message event.
 * @param {object} callback Cloud Function PubSub callback indicating
 *  completion.
 */

exports.pushEventsToWebhook = (event, callback) => {
  try {
    // Parses the Pub/Sub message content
    const payload = event.data ?
        JSON.parse(Buffer.from(event.data, 'base64').toString()) : '';

    if (payload != '') {
      // Read the snapshot's detail from the Pub/Sub message
      const resource = payload.protoPayload.resourceName;
      const principal = payload.protoPayload.authenticationInfo.principalEmail;

      const action = payload.protoPayload.serviceData.policyDelta.bindingDeltas[0].action;
      const role = payload.protoPayload.serviceData.policyDelta.bindingDeltas[0].role;
      const member = payload.protoPayload.serviceData.policyDelta.bindingDeltas[0].member;

      let logScope = '';
      if (resource.startsWith('org')) {
        logScope = resource.split('s/').join('Id=');
      } else {
        logScope = resource.split('s/').join('=');
      }
      const logUrl = `https://console.cloud.google.com/logs/query;cursorTimestamp=${payload.timestamp};query=timestamp%3D%22${payload.timestamp}%22%0AinsertId%3D%22${payload.insertId}%22?${logScope}`; // reqire orgaizationId

      const dateTime = isodate(payload.timestamp);

      // Building the event's content. The latter will be pushed to the webhook
      eventBody = {
        "cards": [
          {
            "header" : {
              "title" : "Manual IAM Change",
              "subtitle" : dateTime
            },
            "sections": [
              {
                "widgets": [
                  {
                    "keyValue": {
                      "topLabel": "Resource",
                      "content": resource,
                      "contentMultiline": "true"
                    }
                  },
                  {
                    "keyValue": {
                      "topLabel": "Principal",
                      "content": principal,
                      "contentMultiline": "true"
                    }
                  },
                  {
                    "keyValue": {
                      "topLabel": "Action",
                      "content": action,
                      "contentMultiline": "true"
                    }
                  },
                  {
                    "keyValue": {
                      "topLabel": "Role",
                      "content": role,
                      "contentMultiline": "true"
                    }
                  },
                  {
                    "keyValue": {
                      "topLabel": "Member",
                      "content": member,
                      "contentMultiline": "true",
                      "button": {
                        "textButton": {
                          "text": "CHECK LOG",
                          "onClick": {
                            "openLink": {
                              "url": logUrl
                            }
                          }
                        }
                      }
                    }
                  }
                ]
              }
            ]
          }
        ]
      };
      // Reads Config Parameters
      const WEBHOOK_URL = process.env.WEBHOOK_URL;

      if (WEBHOOK_URL) {
        // Posting the message to the webhook
        request.post(WEBHOOK_URL, {
          json: eventBody,
        }, (err, res, body) => {
          if (err) {
            console.log('An error occured sending the event to the webhook.');
            console.error(err);
            return;
          }
          console.log(`statusCode: ${res.statusCode}`);
          callback(null, `statusCode: ${res.statusCode}`);
          // console.log(body)
        });
      } else {
        const message = `WEBHOOK_URL environment variable is not set`;
        console.log(message);
        callback(null, message);
      }
    } else {
      const message = `Event message's content is empty.`;
      console.log(message);
      callback(null, message);
    }
  } catch (err) {
    console.log(err);
    callback(err);
  }
};