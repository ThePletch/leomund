'use strict'
# TODO this method returns the email metadata rather than the updated object
console.log('Running update reservation')

doc = require('dynamodb-doc')
dynamo = new doc.DynamoDB()
AWS = require('aws-sdk')
pug = require('pug')
ses = new AWS.SES()
s3  = new AWS.S3()

validStates = [
  "submitted"
  "received"
  "rejected"
  "needsReview"
  "confirmed"
]

exports.handler = (event, context, callback) ->
  console.log('Received event:', JSON.stringify(event, null, 2))

  recordToUpdate = (record) ->
    update = {}
    for key, val of record
      # skip the primary key for updating
      continue if key is "timestamp"
      update[key] =
        Action: 'PUT'
        Value: val
    update

  if event.payload.status in validStates
    itemParams =
      TableName: 'Reservations'
      Key:
        timestamp: event.payload.timestamp
      AttributeUpdates: recordToUpdate(event.payload)
      ReturnValues: 'ALL_NEW'

    dynamo.updateItem itemParams, (error, itemHash) ->
      if error
        console.log(error)
        callback(new Error("Could not find reservation with timestamp #{event.payload.timestamp}."))
      else
        item = itemHash.Attributes
        switch event.payload.status
          when "rejected" # officer rejected the request before it hit neu
            EmailSender.sendEmail(item.requesterEmail, "Your reservation was rejected.",
              "rejected-reservation", {item: item}, callback)
          when "needsReview" # bad response from northeastern, needs review
            EmailSender.sendEmail(EmailSender.eboardEmail, "A reservation needs review.",
              "needs-review-reservation", {item: item}, callback)
          when "received" # got a confirmation email from northeastern
            EmailSender.sendEmail(item.requesterEmail, "Your reservation has been submitted to Northeastern.",
              "received-reservation", {item: item}, callback)
          when "confirmed" # got a completed reservation from northeastern
            # this can be triggered manually by the e-board or automatically by email
            EmailSender.sendEmail(item.requesterEmail, "Your reservation is confirmed.",
              "confirmed-reservation", {item: item}, callback)

  else
    callback(new Error("Invalid state #{event.payload.status}."))
