# TODO move this into a node module
# TODO make emails instance variables so they can be parameterized
class EmailSender
  @sourceEmail: "steve@steve-pletcher.com"
  @eboardEmail: "steven.j.pletcher+eboard@gmail.com"
  @sendEmail: (target, subject, template, data, callback) ->
    fetchTemplate = (templateName, templateCallback) ->
      fileParams =
        Bucket: 'leomund.nutrs.net' # TODO parameterize
        Key: "templates/#{templateName}.pug"
      s3.getObject fileParams, (error, file) ->
        if error
          console.log(error)
          callback(new Error("Failed to fetch template from #{fileParams.Key}."))
        else
          templateCallback(pug.compile(file.Body.toString()))
    buildTemplate = (template, data, buildCallback) ->
      fetchTemplate template, (pugTemplate) ->
        buildCallback(pugTemplate(data))

    buildTemplate template, data, (emailBody) ->
      emailParams =
        Destination:
          ToAddresses: [target]
        Message:
          Body:
            Html:
              Data: emailBody
              Charset: "UTF-8"
          Subject:
            Data: "[Leomund] #{subject}"
            Charset: "UTF-8"
        Source: EmailSender.sourceEmail
      ses.sendEmail(emailParams, callback)
