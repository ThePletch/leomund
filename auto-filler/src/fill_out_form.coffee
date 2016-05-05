'use strict'
console.log('Filling out form.')

doc = require('dynamodb-doc')
dynamo = new doc.DynamoDB()
phantom = require('phantomjs')
page = require('webpage')
formFiller = require('formfiller')
# Expected format for events:
#
# - timestamp: the timestamp of the reservation in question.

exports.handler = (event, context, callback) ->
  console.log('Received event:', JSON.stringify(event, null, 2))
  fetchParams =
    TableName: 'Reservations'
    Key:
      timestamp: event.payload.timestamp
    AttributesToGet: [
      'timestamp'
      'requesterEmail'
      'status'
      'room'
      'attendeeCount'
      'date'
      'startTime'
      'endTime'
      'frequency'
    ]
  dynamo.getItem fetchParams, (error, item) ->
    if error
      callback(new Error("Failed to fetch item: #{error}"))
    else
      page.open formUrl, (status) ->
        if status isnt "success"
          return callback(new Error("Could not access form site. Got status #{status}"))
        else
          page.evaluate(formFiller.nullary(item.Attributes))
