'use strict'
console.log('Running <function name>')

doc = require('dynamodb-doc')
dynamo = new doc.DynamoDB()

# Expected format for events:
#
# - payload: a parameter to pass to the operation
#   e.g. a new reservation's parameters
#
exports.handler = (event, context, callback) ->
  console.log('Received event:', JSON.stringify(event, null, 2))
