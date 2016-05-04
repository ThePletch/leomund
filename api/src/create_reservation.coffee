'use strict'
console.log('Creating reservation')

doc = require('dynamodb-doc')
dynamo = new doc.DynamoDB()

addDefaults = (itemJson) ->
  Object.assign itemJson,
    timestamp: Date.now().toString()
    status: 'requested'

exports.handler = (event, context, callback) ->
  # todo validate passed object, prevent overwrites
  console.log('Received event:', JSON.stringify(event, null, 2))
  itemParams =
    TableName: 'Reservations'
    Item: addDefaults(event.payload)
  dynamo.putItem(itemParams, callback)
