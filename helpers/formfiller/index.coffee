# TODO parameterize
formUrl = "https://fs19.formsite.com/neuemsa/stactacrrf/secure_index.html"

# TODO pull all this stuff into a YAML file
checkboxPrefix = "#RESULT_CheckBox-"
checkboxes = [
  "4_0" # I understand above info etc
  "38"  # Any building works
  "49"  # Agree to T&C
]
textFieldPrefix = "#RESULT_TextField-"
textFields =
  # What club?
  "7": "Northeastern University Tabletop Roleplaying Society"
  # Sched Coord first name [parameterize]
  "8": "Cassandra"
  # Sched Coord last name [parameterize]
  "9": "Binney"
  # Husky email
  "10": "binney.c@husky.neu.edu"
  # Phone number
  "11": "717-283-5145"
radioButtonPrefix = "#RESULT_RadioButton-"
radioButtons =
  # Number of rooms (1 room)
  "14": "Radio-0"
  # Room setup (any setup)
  "18": "Radio-0"
  # Will you be loud (yes)
  "41": "Radio-0"
  # Npn-NU attendees (no)
  "43": "Radio-1"
dynamicRadios =
  numberOfDays: "13" # We don't allow 'two days' or 'three days' options
  startTime: "27" # increments of 30 minutes plus AM/PM (capital)
  endTime: "28"   # see above
dynamicTextFields =
  numberOfAttendees: "17"
  startDate: "25" # Start date uses YYYY-MM-DD format
commentsBox = "#RESULT_TextArea-47"
commentsPrefix = "This reservation submitted by the Leomund automated reservation system. " +
                 "Contact {{devEmail}} with any concerns or bugs.\n\n"

# spits out a 0-argument function that fills in the form with appropriate values for the given item
exports.nullary: (item) ->
  return ->
    # fill in static values
    for checkbox in checkboxes
      $(checkboxPrefix + checkbox).prop('checked', true)
    for id, value of textFields
      $(textFieldPrefix + id).val(value)
    for id, option of radioButtons
      $(radioButtonPrefix + id + " option[value=\"#{option}\"]").prop('selected', true)

    # fill in item-specific info
    dynamicText = {}
    dynamicText[dynamicTextFields.numberOfAttendees] = item.attendeeCount
    dynamicText[dynamicTextFields.startDate] = item.date

    dynamicRadio = {}
    dynamicRadio[dynamicRadios.numberOfDays] = switch item.frequency
      when "once"
        "Radio-0"
      when "weekly"
        "Radio-3"
      when "biweekly"
        "Radio-4"
      when "monthly"
        "Radio-5"
    dynamicRadio[dynamicRadios.startTime] = 0 # TODO
    dynamicRadio[dynamicRadios.endTime] = 0   # TODO

    # TODO sanitize comment field, since it's the only thing we're using html() for
    $(commentsBox).html(commentsPrefix + item.comment)



