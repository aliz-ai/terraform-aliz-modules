const fetch = require('node-fetch');
const googleChatWebhookUrl = process.env.GOOGLE_CHAT_WEBHOOK_URL;

const { IncomingWebhook } = require('@slack/webhook');
const slackWebhookUrl = process.env.SLACK_WEBHOOK_URL;
const slackWebhook = new IncomingWebhook(slackWebhookUrl);

module.exports.notifier = (pubSubEvent, context) => {
  console.log("Google Chat webhook url: " + googleChatWebhookUrl);
  console.log("Slack webhook url: " + slackWebhookUrl)

  const data = decode(pubSubEvent.data);
  const messageText = createMessageText(data, pubSubEvent.attributes);
  console.log(messageText);

  if (googleChatWebhookUrl) {
    fetch(googleChatWebhookUrl, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify({
        text: messageText
      })
    }).then((response) => {
      console.log(response);
    });
  }

  if (slackWebhookUrl) {
    slackWebhook.send({
      text: messageText,
      mrkdwn: true
    });
  }
};

// decode decodes a pubsub event message from base64.
const decode = (data) => {
  return Buffer.from(data, 'base64').toString();
}

const createMessageText = (data, attributes) => {
  // Write the message data and attributes.
  text = `${data}`
  for (var key in attributes) {
    if (attributes.hasOwnProperty(key)) {
      text = text + `\n\t\`${key}: ${attributes[key]}\``
    }
  }
  text = text + "\n\t";
  return text;
}