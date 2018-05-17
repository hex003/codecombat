utils = require '../utils'
request = require '../request'
unsubscribe = require '../../../server/commons/unsubscribe'

pingJson = {
  "type" : "notification_event",
  "app_id" : "...",
  "data" : {
    "type" : "notification_event_data",
    "item" : {
      "type" : "ping",
      "message" : "something something interzen"
    }
  },
  "links" : { },
  "id" : null,
  "topic" : "ping",
  "delivery_status" : null,
  "delivery_attempts" : 1,
  "delivered_at" : 0,
  "first_sent_at" : 1526489523,
  "created_at" : 1526489523,
  "self" : null
}

unsubscribeJson = {
  "type" : "notification_event",
  "app_id" : "...",
  "data" : {
    "type" : "notification_event_data",
    "item" : {
      "type" : "user",
      "id" : "5afc6213d65aaf1cc4ce855a",
      "user_id" : "5afc61e3dc1bd800474819bc",
      "anonymous" : false,
      "email" : "example@email.com",
      "name" : "Joe",
      "app_id" : "...",
      "unsubscribed_from_emails" : true,
      # many more attributes
      "custom_attributes" : {
      }
    }
  },
  "links" : { },
  "id" : "notif_e8c70b50-5929-11e8-ab2a-b3711290f1cd",
  "topic" : "user.unsubscribed",
  "delivery_status" : "pending",
  "delivery_attempts" : 1,
  "delivered_at" : 0,
  "first_sent_at" : 1526489716,
  "created_at" : 1526489716,
  "self" : null
}

url = utils.getUrl('/webhooks/intercom')

describe 'POST /webhooks/intercom', ->
  it 'returns 200 when it receives a ping', utils.wrap ->
    [res] = yield request.postAsync({url, json: pingJson})
    expect(res.statusCode).toBe(200)
    
  it 'calls unsubscribe.unsubscribeEmail for the given email for user.unsubscribed events', utils.wrap ->
    spyOn(unsubscribe, 'unsubscribeEmail')
    [res] = yield request.postAsync({url, json: unsubscribeJson})
    expect(res.statusCode).toBe(200)
    expect(unsubscribe.unsubscribeEmail).toHaveBeenCalled()
    expect(unsubscribe.unsubscribeEmail.calls.argsFor(0)[0]).toBe(unsubscribeJson.data.item.email)
