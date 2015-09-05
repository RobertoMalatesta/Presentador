###
This function takes the Easypedia JSON and makes the section's HTML.
However, it doesn't interact with the DOM, so another file has to add it.

quick definitions:
  sentence: a single sentence
  slide: sentences grouped on a single screen
  subsection: a subsection from Wikipedia that Easypedia returned
  section: all the slides- goes linearly vertically
###

make =
  id: require "./create/id.coffee"
  name: require "./create/name.coffee"
  pseudosection: require "./create/pseudosection.coffee"
  section: require "./create/section.coffee"

module.exports = (json) ->
  # set up the variables that will be used
  id = make.id json.name
  name = make.name json.name

  # if the section is already added, don't readd it
  if document.getElementById(id)?
    return

  # hash separates the title and subtitle
  # if there is a hash, it means that only part should be added
  if "#" in json.name # only add a subsection
    make.pseudosection name, json.text[name]
  else # add every section from the JSON
    make.section name, json.text
