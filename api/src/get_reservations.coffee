'use strict'
console.log('Getting reservations')

doc = require('dynamodb-doc')
dynamo = new doc.DynamoDB()

exports.handler = (event, context, callback) ->
  console.log('Received event:', JSON.stringify(event, null, 2))
  scanParams =
    TableName: 'Reservations'
    Limit: 20
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
  # TODO: Pagination, filter by status
  dynamo.scan(scanParams, callback)
