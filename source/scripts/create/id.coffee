###
This file makes the ID that is applied to the HTML
To create the id, pass in the name of the section
###

module.exports = (name) ->
  # an HTML id has the following constraints:
  # cannot have punctuation
  # cannot have spaces
  # is case-sensitive
  # the following regexes handle each constraint

  name
    .replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, "") # remove punctuation
    .replace(/\s{2,}/g,"") # clean any text broken from removing punctuation
    .replace(/ /g, "-") # remove spaces
    .replace(/'/g, "") # remove apostrophes
    .toLowerCase()
