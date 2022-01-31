const fetch = require('node-fetch');

const googleChatWebhookUrl = process.env.GOOGLE_CHAT_WEBHOOK_URL;

module.exports.notifier = (pubSubEvent, context) => {
  const data = decode(pubSubEvent.data);
  const message = JSON.stringify(createMessage(data, pubSubEvent.attributes));
  console.log(message);
  fetch(googleChatWebhookUrl, {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: message
  }).then((response) => {
    console.log(response);
  });
};

// decode decodes a pubsub event message from base64.
const decode = (data) => {
  return Buffer.from(data, 'base64').toString();
}

const createMessage = (data, attributes) => {
  // Write the message data and attributes.
  text = `${data}`
  for (var key in attributes) {
    if (attributes.hasOwnProperty(key)) {
      text = text + `\n\t\`${key}: ${attributes[key]}\``
    }
  }
  text = text + "\n\t";
  const message = {
    text: text,
  };
  return message;
}